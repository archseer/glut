/*
 * Last edit by previous maintainer:
 * 2000/01/06 16:37:43, kusano
 *
 * Copyright (C) 1999 - 2005 Yoshi <yoshi@giganet.net>
 * Copyright (C) 2006 John M. Gabriele <jmg3000@gmail.com>
 * Copyright (C) 2007 James Adam <james@lazyatom.com>
 * Copyright (C) 2007 Jan Dvorak <jan.dvorak@kraxnet.cz>
 *
 * This program is distributed under the terms of the MIT license.
 * See the included MIT-LICENSE file for the terms of this license.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef _COMMON_H_
#define _COMMON_H_

#include <ruby.h>
#include "extconf.h"

#ifdef HAVE_GLUT_GLUT_H
#include <GLUT/freeglut.h>
#endif

#ifdef HAVE_GL_GLUT_H
#include <GL/freeglut.h>
#endif

#ifndef GLUTCALLBACK
#define GLUTCALLBACK
#endif

#ifdef HAVE_WINDOWS_H
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT
#endif

/* these two macros are cast to a 32 bit type in the places they are used */
#ifndef RARRAY_LENINT
#define RARRAY_LENINT RARRAY_LEN
#endif

/* GLUT */

#define GLUT_SIMPLE_FUNCTION(_name_) \
static VALUE \
glut_##_name_(obj) \
VALUE obj; \
{ \
    glut##_name_(); \
    return Qnil; \
}

VALUE rb_glut_check_callback(VALUE, VALUE);

#endif
