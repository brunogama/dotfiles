# coding: utf8
# Author: Bruno Gama
# This is my goddamn Python RC.
#
# import sys
# import os
# import readline, rlcompleter
# import atexit
# import pprint
# from tempfile import mkstemp
# from code import InteractiveConsole
# import datetime
# import pdb
# import re
# import json
# from timeit import Timer

# try:
#     from urllib2 import urlopen
# except ImportError:  # pragma: no cover
#     # For Python 3.
#     from urllib.request import urlopen


# # Color Support
# ###############

# class TermColors(dict):
#     """Gives easy access to ANSI color codes. Attempts to fall back to no color
#     for certain TERM values. (Mostly stolen from IPython.)"""

#     COLOR_TEMPLATES = (
#         ("Black", "0;30"),
#         ("Red", "0;31"),
#         ("Green", "0;32"),
#         ("Brown", "0;33"),
#         ("Blue", "0;34"),
#         ("Purple", "0;35"),
#         ("Cyan", "0;36"),
#         ("LightGray", "0;37"),
#         ("DarkGray", "1;30"),
#         ("LightRed", "1;31"),
#         ("LightGreen", "1;32"),
#         ("Yellow", "1;33"),
#         ("LightBlue", "1;34"),
#         ("LightPurple", "1;35"),
#         ("LightCyan", "1;36"),
#         ("White", "1;37"),
#         ("Normal", "0"),
#     )

#     NoColor = ''
#     _base = '\001\033[%sm\002'

#     def __init__(self):
#         if os.environ.get('TERM') in ('Eterm', 'linux', 'putty', 'rxvt',
#                                       'screen', 'screen-256color',
#                                       'screen-bce', 'vt100', 'xterm',
#                                       'xterm-256color', 'xterm-color'):
#             self.update(
#                 dict([(k, self._base % v) for k, v in self.COLOR_TEMPLATES])
#             )
#         else:
#             self.update(
#                 dict([(k, self.NoColor) for k, v in self.COLOR_TEMPLATES])
#             )
# _c = TermColors()

# # Enable a History
# ##################

# HISTFILE = "%s/.pyhistory" % os.environ["HOME"]

# # Read the existing history if there is one
# if os.path.exists(HISTFILE):
#     try:
#         readline.read_history_file(HISTFILE)
#     except IOError:
#         # I'm assuming this is caused by Pypy and Python?
#         pass

# # Set maximum number of items that will be written to the history file
# readline.set_history_length(300)

# def savehist():
#     readline.write_history_file(HISTFILE)

# atexit.register(savehist)

# # Enable Color Prompts
# ######################

# sys.ps1 = '%s>>> %s' % (_c['Blue'], _c['Normal'])
# sys.ps2 = '%s... %s' % (_c['Red'], _c['Normal'])

# # Enable Pretty Printing for stdout
# ###################################


# def the_displayhook(value):
#     if value is not None:
#         try:
#             import __builtin__
#             __builtin__._ = value
#         except ImportError:
#             __builtins__._ = value

#         pprint.pprint(value)
# sys.displayhook = the_displayhook

# # Welcome message
# #################

# WELCOME = """
# %(Red)s
# You've got color, history, and pretty printing.
# (If your ~/.inputrc doesn't suck, you've also
# got completion and vi-mode keybindings.)
# %(Purple)s
# Type \e to get an external editor.
# %(Normal)s""" % _c

# atexit.register(lambda: sys.stdout.write("""%(DarkGray)s
# And that was that.\n
# %(Normal)s""" % _c))

# # Django Helpers
# ################

# def SECRET_KEY():
#     "Generates a new SECRET_KEY that can be used in a project settings file."
#     return os.urandom(24)

# # If we're working with a Django project, set up the environment
# if 'DJANGO_SETTINGS_MODULE' in os.environ:
#     from django.db.models.loading import get_models
#     from django.test.client import Client
#     from django.test.utils import (
#         setup_test_environment,
#         teardown_test_environment
#     )
#     from django.conf import settings as S

#     class DjangoModels(object):
#         """Loop through all the models in INSTALLED_APPS and import them."""
#         def __init__(self):
#             for m in get_models():
#                 setattr(self, m.__name__, m)

#     A = DjangoModels()
#     C = Client()

#     WELCOME += """%(Green)s
# Django environment detected.
# * Your INSTALLED_APPS models are available as `A`.
# * Your project settings are available as `S`.
# * The Django test client is available as `C`.
# %(Normal)s""" % _c

#     setup_test_environment()
#     S.DEBUG_PROPAGATE_EXCEPTIONS = True

#     WELCOME += """%(Purple)s
# Warning: the Django test environment has been set up; to restore the
# normal environment call `teardown_test_environment()`.

# Warning: DEBUG_PROPAGATE_EXCEPTIONS has been set to True.
# %(Normal)s""" % _c

# # Start an external editor with \e
# ##################################
# # http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/438813/

# # MAC_VIM = '/Applications/MacVim.app/Contents/MacOS/Vim'
# EDITOR = os.environ.get('EDITOR', 'vim')
# EDIT_CMD = '\e'

# class EditableBufferInteractiveConsole(InteractiveConsole):
#     def __init__(self, *args, **kwargs):
#         self.last_buffer = [] # This holds the last executed statement
#         InteractiveConsole.__init__(self, *args, **kwargs)

#     def runsource(self, source, *args):
#         self.last_buffer = [ source.encode('utf-8') ]
#         return InteractiveConsole.runsource(self, source, *args)

#     def raw_input(self, *args):
#         line = InteractiveConsole.raw_input(self, *args)
#         if line == EDIT_CMD:
#             fd, tmpfl = mkstemp('.py')
#             os.write(fd, b'\n'.join(self.last_buffer))
#             os.close(fd)
#             # I use MacVim's updated vim, but you can also use
#             # EDITOR in the first variable of the line below.
#             os.system('%s %s' % (EDITOR, tmpfl))
#             line = open(tmpfl).read()
#             os.unlink(tmpfl)
#             tmpfl = ''
#             lines = line.split( '\n' )
#             for i in range(len(lines) - 1): self.push( lines[i] )
#             line = lines[-1]
#         return line

# c = EditableBufferInteractiveConsole(locals=locals())
# c.interact(banner=WELCOME)

# # Exit the Python shell on exiting the InteractiveConsole
# sys.exit()


# class PythonRC(object):
#     """docstring for PythonRC"""

#     class TabCompletion:
#         '''
#         The name explains it self
#         '''
#         pass

#     class LetsMakeHistory:
#         '''
#         '''
#         def __init__(self):
#             history_path = os.path.expanduser("~/.pyhistory")
#             if os.path.isfile(history_path):
#                 readline.read_history_file(history_path)

#             atexit.register(
#                 lambda x=history_path: readline.write_history_file(x))

#     class TermColors(dict):  # Because the world without colors is boring
#         """Gives easy access to ANSI color codes. Attempts to fall back
#         to no color for certain TERM values.
#         Mostly stolen from IPython.
#         """

#         COLOR_TEMPLATES = (
#             ("Black", "0;30"),
#             ("Red", "0;31"),
#             ("Green", "0;32"),
#             ("Brown", "0;33"),
#             ("Blue", "0;34"),
#             ("Purple", "0;35"),
#             ("Cyan", "0;36"),
#             ("LightGray", "0;37"),
#             ("DarkGray", "1;30"),
#             ("LightRed", "1;31"),
#             ("LightGreen", "1;32"),
#             ("Yellow", "1;33"),
#             ("LightBlue", "1;34"),
#             ("LightPurple", "1;35"),
#             ("LightCyan", "1;36"),
#             ("White", "1;37"),
#             ("Normal", "0"),
#         )

#         NoColor = ''
#         _base = '\001\033[%sm\002'

#         def __init__(self):
#             if os.environ.get('TERM') in ('Eterm', 'linux', 'putty', 'rxvt',
#                                           'screen', 'screen-256color',
#                                           'screen-bce', 'vt100', 'xterm',
#                                           'xterm-256color', 'xterm-color'):
#                 self.update({k: self._base % v
#                             for k, v in self.COLOR_TEMPLATES})
#             else:
#                 self.update({k: self.NoColor
#                             for k, v in self.COLOR_TEMPLATES})

#     def __init__(self, arg):
#         super(PythonRC, self).__init__()
#         self.arg = arg
#         self._c = self.TermColors()
#         print arg


# def main():
#     pythonrc = PythonRC('a')



# if __name__ == '__main__':
#     main()
