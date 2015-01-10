from biostar.settings.base import *  # first line of deploy.py 

# Turn off debug mode on deployed servers.
DEBUG = False
# Should the django compressor be used.
USE_COMPRESSOR = True
# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# In a Windows environment this must be set to your system time zone.
TIME_ZONE = 'Europe/Istanbul'
# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'tr'

ALLOWED_HOSTS.append(u'btsorucevap.com')
ALLOWED_HOSTS.append(u'www.btsorucevap.com')

DATABASES = {
    'default': {
        # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'btsc',
        'USER': 'btsc',
        'PASSWORD': 'btsc@12!',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

LIVE_DIR = abspath(HOME_DIR, 'live/btsorucevap')
DATABASE_NAME = abspath(LIVE_DIR, get_env("DATABASE_NAME"))
# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/var/www/example.com/static/"
EXPORT_DIR = abspath(LIVE_DIR, "export")
STATIC_ROOT = abspath(EXPORT_DIR, "static")

# This is where the planet files are collected
PLANET_DIR = abspath(LIVE_DIR, "planet")

# Absolute filesystem path to the directory that will hold user-uploaded files.
MEDIA_ROOT = abspath(EXPORT_DIR, "media")

# Default search index location.
WHOOSH_INDEX = abspath(LIVE_DIR, "whoosh_index")