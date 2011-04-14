from mongoengine import *
import datetime

connect('soapboxdb')

class Root(object):
    def __init__(self, request):
        self.request = request

class Tag(Document):
    label = StringField(required=True)
    tag_type = StringField(required=True)
    tag_permission = IntField(required=True)

class Reply(EmbeddedDocument):
    body = StringField(required=True)
    author = ReferenceField('User')
    name = StringField(max_length=120)
    date_created = DateTimeField(default=datetime.datetime.utcnow)
    ups = IntField(default=0)
    downs = IntField(default=0)
    spams = IntField(default=0)
    ranking = FloatField(default=0)

class SearchTerm(EmbeddedDocument):
    term = StringField()
    weight = FloatField()

class Message(Document):
    body = StringField(required=True)
    tags = ListField(ReferenceField(Tag))
    author = ReferenceField('User')
    date_created = DateTimeField(default=datetime.datetime.utcnow)
    ups = IntField(default=0)
    downs = IntField(default=0)
    opens = IntField(default=0)
    boxeds = IntField(default=0)
    spams = IntField(default=0)
    exclusivity = FloatField(default=0)
    age_range_start = IntField()
    age_range_end = IntField()
    to_males = BooleanField(default=False)
    to_females = BooleanField(default=False)
    location = GeoPointField()
    radius = FloatField()
    ranking = FloatField(default=0)
    replies = ListField(EmbeddedDocumentField(Reply))
    terms = ListField(EmbeddedDocumentField(SearchTerm))

class User(Document):
    email = StringField(required=True, unique=True)
    password = StringField(required=True)
    sex = StringField(required=True)
    dob = DateTimeField(required=True)
    personal_tag = ReferenceField(Tag, required=True)
    first_name = StringField()
    last_name = StringField()
    salt = StringField(required=True)
    tag_bucket = ListField(ReferenceField('Tag'))
    date_created = DateTimeField(default=datetime.datetime.utcnow)
    boxed_messages = ListField(ReferenceField(Message))
    spamed_messages = ListField(ReferenceField(Message))
    read_messages = ListField(ReferenceField(Message))
    uped_messages = ListField(ReferenceField(Message))
    downed_messages = ListField(ReferenceField(Message))

