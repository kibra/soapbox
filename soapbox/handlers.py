from pyramid_handlers import action
from pyramid.httpexceptions import HTTPFound

import formencode
from formencode import Schema, validators, compound
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer

from pyramid.security import remember
from pyramid.security import forget
from pyramid.security import authenticated_userid
from pyramid.response import Response

from mongoengine import *

from datetime import datetime
import os
from math import log
import hashlib
import random
from uuid import uuid4,UUID
import json

import bleach

from soapbox import resources

def find_pub_id (tagid, a_list):
	for pair in a_list:
		if tagid == pair[1]:
			return pair[0]
	return False

def find_tagid_id (pup_id, a_list):
	for pair in a_list:
		if pup_id == pair[0]:
			return pair[1]
	return False

class EmailValidator(validators.Email):
    def _to_python(self, value, state):
        email_in_use = True
        try:
            result = resources.User.objects.get(email=value)
        except resources.User.DoesNotExist, e:
            email_in_use = False
        if email_in_use:
            raise formencode.Invalid('Email already in use.', value, state)
        return value

class dobValidator(validators.DateConverter):
    def _to_python(self, value, state):
        dob_valid = True
        try:
            dob = datetime.strptime(value, '%Y-%B-%d')
        except ValueError, e:
            dob_valid = False
        except TypeError, e:
            dob_valid = False
        if not dob_valid:
            raise formencode.Invalid('Not a valid date.', value, state)
            return value    
        return dob

class UserSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    email = EmailValidator(not_empty=True)
    password = validators.String(not_empty=True)
    confirm_password = validators.String(not_empty=True)
    chained_validators = [validators.FieldsMatch('password','confirm_password')]
    sex = validators.String(not_empty=True)
    dob = dobValidator(not_empty=True)
    first_name = validators.String()
    last_name = validators.String()

class InvalidUser(Exception):
    pass

def hash_password(password, salt):
    m = hashlib.sha256()
    m.update(password)
    m.update(salt)
    return m.hexdigest()

def gen_hash_password(password):
    import random
    letters = 'abcdefghijklmnopqrstuvwxyz0123456789'
    p = ''
    random.seed()
    for x in range(32):
        p += letters[random.randint(0, len(letters)-1)]
    return hash_password(password, p), p

def authenticate_user(email, password):
    try:  
        user = resources.User.objects.get(email=email)
    except resources.User.DoesNotExist, e:
        raise InvalidUser('bad email')
    else:
        if not hash_password(password, user.salt) == user.password:
            raise InvalidUser('bad password')
        return user

_here = os.path.dirname(__file__)
_public_box = open(os.path.join(_here, 'templates', 'public_box.html')).read()
_box = open(os.path.join(_here, 'templates', 'box.html')).read()

class Home(object):
    def __init__(self, request):
        self.request = request

    def change_filter(self):
        if len(self.request.params.keys()) == 0:
            return HTTPFound(location='/reset_filter')
        filter_tags = {}
        for param, value in self.request.params.iteritems():
            if param == 'filter_public_tag':
                filter_tags[uuid4()] = self.request.session['public_tags'][UUID(value)]['id']
            if param == 'filter_personal_tag':
                filter_tags[uuid4()] = self.request.session['personal_tag'][UUID(value)]['id']
        self.request.session['filter_tags'] = filter_tags
        return HTTPFound(location='/box')
 
    @action(renderer='public_box.mak')
    def index(self):
        if authenticated_userid(self.request):
            return HTTPFound(location='/box')
        public_tags_list = resources.Tag.objects(tag_type='public')
        filter_public_tags = {}
        public_tags = []
        for tag in public_tags_list:
            tag_uuid = uuid4()
            filter_public_tags[tag_uuid] = {'id':tag.id, 'label':tag.label}
            public_tags.append({'uuid':tag_uuid, 'label':tag.label})
        #return Response(content_type='text/html', body=_public_box)
        return {}

class Box(object):
    def __init__(self, request):
        self.request = request

    @action(renderer='box.mak')
    def index(self):
        id=authenticated_userid(self.request)
        if not id:
            return HTTPFound(location='/')
        #return Response(content_type='text/html', body=_box)
        return {}

    @action(renderer='send.mak')
    def send(self):
        id=authenticated_userid(self.request)
        if not id:
            return HTTPFound(location='/')
        user = resources.User.objects.get(id=id)
        personal_tag = resources.Tag.objects.get(id=user.personal_tag.id)
        personal_tag = {uuid4():{'id':personal_tag.id, 'label':personal_tag.label}}
        self.request.session['personal_tag'] = personal_tag
        public_tags_list = resources.Tag.objects(tag_type='public')
        public_tags = {}
        for tag in public_tags_list:
            public_tags[uuid4()] = {'id':tag.id, 'label':tag.label}
        self.request.session['public_tags'] = public_tags
        available_tags = []
        for tag in public_tags_list:
            available_tags.append({'id':tag.id, 'label':tag.label})
        self.request.session['available_tags'] = available_tags
        return {'user':user, 'personal_tag':personal_tag, 'available_tags':available_tags}
    
    @action(renderer='other_box.mak')
    def box2(self):
        return {}
	
    def logout(self):
        headers = forget(self.request)
        self.request.session.delete()
        return HTTPFound(location='/', headers=headers)

class Messages(object):
    def __init__(self, request):
        self.request = request

    @action(renderer='messages.mak')
    def all(self):
        return {'messages' : resources.Message.objects}

class Auth(object):
    def __init__(self, request):
        self.request = request
    
    @action(request_method='POST')
    def login_post(self):
        try:
            user = authenticate_user(self.request.params['email'], self.request.params['password'])
        except InvalidUser, e:
            return HTTPFound(location='/')
        headers = remember(self.request, str(user.id))
        return HTTPFound(location='/box', headers=headers)
    
    @action(renderer="register.mak")
    def register(self):
        form = Form(self.request, schema=UserSchema)
        if form.validate():
            user = form.bind(resources.User())
            user.password, user.salt = gen_hash_password(user.password)
            personal_tag = resources.Tag()
            personal_tag.label = user.email
            personal_tag.tag_type = 'user'
            personal_tag.tag_permission = 2
            personal_tag.save()
            user.personal_tag = personal_tag
            user.save()
            user = authenticate_user(self.request.params['email'], self.request.params['password'])
            headers = remember(self.request, str(user.id))
            return HTTPFound(location="/", headers=headers)
        return {'renderer':FormRenderer(form)}

    @action(renderer='registered.mak')
    def registered(self):
        if not authenticated_userid(self.request):
            return HTTPFound(location='/')
        user = resources.User.objects.get(id=authenticated_userid(self.request))
        return {'user':user}

class Tests(object):
    def __init__(self, request):
        self.request = request

    def all_messages(self):
        messages = resources.Message.objects().order_by('-date_created')
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'age_range_end':message.age_range_end,'age_range_start':message.age_range_start,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags]}))
        return Response(body=json.dumps(messages_array))    

    def filter_tags(self):
        if self.request.session.has_key('filter_tags'):
            return Response(body=str(self.request.session['filter_tags']))
        return Response(body='no filter tag')
        
    def emailsdf126700(self):
        emails = resources.User.objects()
        array = []
        for email in emails:
            array.append(email.email)
        return Response(body=json.dumps(array))

    def age_e(self):
        today = datetime.today()
        dobs = [user.dob for user in resources.User.objects()]
        number_of_users = resources.User.objects().count()
        start_dob = today.replace(year=today.year-20)
        end_dob = today.replace(year=today.year-25)
        matches = 0.0
        for dob in dobs:
            if start_dob >=  dob >= end_dob:
                matches = matches + 1
        age_e = matches/number_of_users
        return Response(body=str(age_e))

    def create_tags(self):
        tag_list = ['borrow','party']
        for tag_label in tag_list:
            tag = resources.Tag()
            tag.label = tag_label
            tag.tag_type = 'default'
            tag.tag_permission = 0
            tag.save()

    def create_message(self):
        message = resources.Message()
        message.body = "best text everr!!!"
        tags = resources.Tag.objects()          
        for tag in tags:
            message.tags.append(tag)
            break
        message.ups = 12
        message.downs = 2
        message.ranking = 3
        message.save()
        return Response(body="tasetasetaset")

    def edit_tags(self):
        tag = resources.Tag.objects(label='public')[0]
        print tag.tag_type
        tag.tag_type = 'public'
        tag.save()
        print tag.tag_type
        
        tag_array = []
        tags = resources.Tag.objects()
        for tag in tags:
            tag_array.append((tag.label, tag.tag_type))
        return Response(json.dumps(tag_array))

def get_pub_messageid(messageid, request):
    if not request.session.has_key('cookied_messages'):
        request.session['cookied_messages'] = [messageid]
    if messageid not in request.session['cookied_messages']:
        request.session['cookied_messages'].append(messageid)
    return request.session['cookied_messages'].index(messageid)

def get_pub_tagid(tagid, request):
    if not request.session.has_key('cookied_tags'):
        request.session['cookied_tags'] = [tagid]
    if tagid not in request.session['cookied_tags']:
        request.session['cookied_tags'].append(tagid)
    return (request.session['cookied_tags'].index(tagid),resources.Tag.objects.get(id=tagid).label)

def get_pub_messageid(messageid, request):
    if not request.session.has_key('cookied_messages'):
        request.session['cookied_messages'] = [messageid]
    if messageid not in request.session['cookied_messages']:
        request.session['cookied_messages'].append(messageid)
    return request.session['cookied_messages'].index(messageid)

def find_cookied_messageid(pubid, request):
    if not request.session.has_key('cookied_messages'):
        return None
    return request.session['cookied_messages'][pubid]

def find_cookied_tagid(pubid, request):
    if not request.session.has_key('cookied_tags'):
        return None
    return request.session['cookied_tags'][pubid]

def get_ranking(message):
    epoch = datetime(1970, 1, 1)
    td = message.date_created - epoch
    seconds = td.days * 86400 + td.seconds + (float(td.microseconds) / 1000000) - 1134028003
    score = message.ups - message.downs
    order = log(max(abs(score), 1), 10)
    sign = 1 if score > 0 else -1 if score < 0 else 0
    return round(order + sign * seconds / 45000, 7)

class JSON(object):
    def __init__(self, request):
        self.request = request
    
    def message(self):
        pubid =  self.request.matchdict.get('pubid', None)
        if not pubid:
            return Response(body="bad pubid number")
        message = resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request))
        if not message:
            return Response(body="no cookies")
        if self.request.method == 'GET':
            return Response(body=json.dumps((get_pub_messageid(message.id,self.request),
            {'body':message.body,
            'replies':[{'body':reply.body,'score':reply.ups-reply.downs,'author':reply.author.email} for reply in message.replies],
            'ups':message.ups,'downs':message.downs,
            'score':message.ups - message.downs,
            'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags if tag.tag_type=='default' or tag.tag_type=='user']})))
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            print "message post but not logged in"
            return Response(body="not logged in")
        if self.request.params['data']:
            data = json.loads(self.request.params['data'])
        else:
            return Response(body="no post data")
        if 'add_reply' in data:
            reply = resources.Reply()
            reply.body = data['add_reply']
            reply.author = user
            message.replies.append(reply)
        if 'uped' in data:
            if data['uped']:
                if message not in user.uped_messages:
                    try:
                        user.downed_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                        message.downs = message.downs - 1
                    except ValueError:
                        pass
                    user.uped_messages.append(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.ups = message.ups + 1
                else:
                    return Response(status=403) 
            else:
                if message in user.uped_messages:
                    user.uped_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.ups = message.ups - 1
        elif 'downed' in data:
            if data['downed']:
                if message not in user.downed_messages:
                    try:
                        user.uped_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                        message.ups = message.ups - 1
                    except ValueError:
                        pass
                    user.downed_messages.append(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.downs = message.downs + 1
                else:
                    return Response(status=403) 
            else:
                if message in user.downed_messages:
                    user.downed_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.downs = message.downs - 1
        elif 'boxed' in data:
            if data['boxed']:
                if message not in user.boxed_messages:
                    user.boxed_messages.append(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.boxeds = message.boxeds + 1
            else:
                if message in user.boxed_messages:
                    user.boxed_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.boxeds = message.boxeds - 1
        elif 'spam' in data:
            if data['spam']:
                if message not in user.spamed_messages:
                    user.spamed_messages.append(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.spams = message.spams + 1
            else:
                if message in user.spamed_messages:
                    user.spamed_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.spams = message.spams - 1
        elif 'read' in data:
            if data['read']:
                if message not in user.read_messages:
                    user.read_messages.append(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.opens = message.opens + 1
            else:
                if message in user.read_messages:
                    user.read_messages.remove(resources.Message.objects.get(id=find_cookied_messageid(int(pubid), self.request)))
                    message.opens = message.opens - 1
        message.ranking = get_ranking(message)
        message.save()
        user.save()
        return Response(body=json.dumps({'score':message.ups - message.downs}),status=200)

    def public_messages(self):
        page = self.request.matchdict.get('page', None)
        if not page:    
            return Response(body="no page number")
        messages = resources.Message.objects(tags__in=resources.Tag.objects(tag_type='public')).order_by("-ranking")[18*(int(page)-1):18*(int(page)-1)+18]
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'ups':message.ups,'downs':message.downs,'score':message.ups - message.downs,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags if tag.tag_type=='default']}))
        return Response(body=json.dumps(messages_array))
    
    def my_messages(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        page = self.request.matchdict.get('page', None)
        if not page:
            return Response(body="no page number")
        messages = resources.Message.objects(tags__in=user.tag_bucket).order_by("-ranking")[18*(int(page)-1):18*(int(page)-1)+18]
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),
            {'body':message.body,
            'ups':message.ups,
            'downs':message.downs,
            'score':message.ups - message.downs,
            'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags],
            'uped':message in user.uped_messages,
            'downed':message in user.downed_messages,
            'read':message in user.read_messages}))
        return Response(body=json.dumps(messages_array))

    def search_messages(self):   
        if self.request.params['data']:
	        data = json.loads(self.request.params['data'])
        else:
            return Response(body="no data")
        if data['terms']:
	        terms_text = data['terms']
        else:
            return Response(body="no terms")
        messages = resources.Message.objects(terms__term__in=terms_text)
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'ups':message.ups,'downs':message.downs,'score':message.ups - message.downs,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags]}))
        return Response(body=json.dumps(messages_array))


    def uped_messages(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        messages_array = []
        for message in user.uped_messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'score':message.ups - message.downs,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags]}))
        return Response(body=json.dumps(messages_array))

    def boxed_messages(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        page = self.request.matchdict.get('page', None)
        if not page:
            return Response(body="no page number")
        messages = user.boxed_messages[18*(int(page)-1):18*(int(page)-1)+18]
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'score':message.ups - message.downs,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags]}))
        return Response(body=json.dumps(messages_array))

    def user(self):
        id=authenticated_userid(self.request)
        if id:
            return Response(body=json.dumps({'email':resources.User.objects.get(id=id).email}))
        else:
            return Response(body="not logged in")
        
    def sent_messages(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        page = self.request.matchdict.get('page', None)
        if not page:    
            return Response(body="no page number")
        messages = resources.Message.objects(author=user).order_by("-ranking")[18*(int(page)-1):18*(int(page)-1)+18]
        messages_array = []
        for message in messages:
            messages_array.append((get_pub_messageid(message.id,self.request),{'body':message.body,'score':message.ups - message.downs,'tags':[get_pub_tagid(tag.id,self.request) for tag in message.tags]}))
        return Response(body=json.dumps(messages_array))

    @action(request_method='POST')
    def send_message(self):
        if self.request.params['data']:
	        data = json.loads(self.request.params['data'])
        else:
            return Response(body="no data")
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        for k,v in data.iteritems():
            print k,v
        for index, tag in enumerate(data['tags']):
            data['tags'][index] = int(tag)
        epoch = datetime(1970, 1, 1)
        if 'body' in data and 'tags' in data:
            message = resources.Message()
            if 'from' in data:
                message.age_range_start = data['from']
            if 'to' in data:
                message.age_range_end = data['to']
            if 'sex' in data:
                if data['sex'] == 'males':
                    message.to_males = True
                elif data['sex'] == 'females':
                    message.to_females = True
            else:
                message.to_males = True
                message.to_females = True
            message.body = bleach.linkify(data['body'])
            message.author = user
            for tag in data['tags']:
                message.tags.append(resources.Tag.objects.get(id=find_cookied_tagid(tag, self.request)))
            message.save()
            message.ups = 1
            user.uped_messages = message
            message.ranking = get_ranking(message)
            BAD_CHARS = ".!?,\'\""
            words = [ word.strip(BAD_CHARS) for word in message.body.strip().split() if len(word) > 4 ]
            word_freq = {}
            for word in words :
                word_freq[word] = word_freq.get(word, 0) + 1
            tx = [ (v, k) for (k, v) in word_freq.items()]
            tx.sort(reverse=True)
            word_freq_sorted = [ (k, v) for (v, k) in tx ]
            for term_pair in word_freq_sorted:
                searchterm = resources.SearchTerm()
                searchterm.term = term_pair[0]
                searchterm.weight = term_pair[1]
                message.terms.append(searchterm)
            message.save()
        return Response(body="OK")

    def send_tags(self):
        postable_tags = {'default_tags':[]}
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
            postable_tags['personal_tag'] = resources.Tag.objects.get(id=user.personal_tag.id).id
            postable_tags['personal_tag'] = get_pub_tagid(postable_tags['personal_tag'],self.request)
        default_tags = resources.Tag.objects(tag_type='default')
        for tag in default_tags:
            postable_tags['default_tags'].append(get_pub_tagid(tag.id,self.request))
        postable_tags['public_tag'] = resources.Tag.objects.get(tag_type='public').id
        postable_tags['public_tag'] = get_pub_tagid(postable_tags['public_tag'],self.request)
        return Response(body=json.dumps(postable_tags))

    def tags(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        if self.request.method == 'GET':
            default_tags = []
            public_tags = []
            my_tags = []
            for tag in resources.Tag.objects(tag_type='default'):
                default_tags.append(get_pub_tagid(tag.id,self.request))
            for tag in user.tag_bucket:
                my_tags.append(get_pub_tagid(tag.id,self.request))
            return Response(body=json.dumps({'default_tags':default_tags,'public_tag':get_pub_tagid(resources.Tag.objects(tag_type='public')[0].id,self.request),'my_tags':my_tags}))
        if self.request.params['data']:
	        data = json.loads(self.request.params['data'])
        else:
            return Response(body="no data")
        if 'add_tags' in data:
            for index, tag in enumerate(data['add_tags']):
                data['add_tags'][index] = int(tag)
            for tag in data['add_tags']:
                tag = resources.Tag.objects.get(id=find_cookied_tagid(tag, self.request))
                if tag not in user.tag_bucket:
                    user.tag_bucket.append(tag)
        if 'remove_tags' in data:
            for index, tag in enumerate(data['remove_tags']):
                data['remove_tags'][index] = int(tag)
            for tag in data['remove_tags']:
                tag = resources.Tag.objects.get(id=find_cookied_tagid(tag, self.request))
                print tag
                if tag in user.tag_bucket:
                    print user.tag_bucket
                    user.tag_bucket.remove(tag)
        user.save()
        return Response(body="OK")

    def remove_tags(self):
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
        else:
            return Response(body="not logged in")
        if self.request.params['data']:
	        data = json.loads(self.request.params['data'])
        else:
            return Response(body="no data")
        if 'remove_tags' in data:
            for index, tag in enumerate(data['remove_tags']):
                data['add_tags'][index] = int(tag)
            for tag in data['remove_tags']:
                tag = resources.Tag.objects.get(id=find_cookied_tagid(tag, self.request))
                if tag not in user.tag_bucket:
                    user.tag_bucket.append(tag)
        user.save()
        return Response(body="OK")

    def public_tags(self):
        public_tags_array = []
        id=authenticated_userid(self.request)
        if id:
            user = resources.User.objects.get(id=id)
            public_tags = resources.Tag.objects(tag_type='default')
            for tag in public_tags:
                public_tags_array.append(get_pub_tagid(tag.id,self.request))
            return Response(body=json.dumps(public_tags_array))
        else:
            return Response(body="not loged in")
