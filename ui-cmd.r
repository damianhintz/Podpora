#include <rscdefs.h>
#include <cmdclass.h>

#define CT_NONE 0
#define CT_MAIN 1
#define CT_MENU 10
#define CT_PHOTO 101
#define CT_CONFIG 102
#define CT_ARROW 103
#define CT_LOAD 104

Table CT_MAIN =
{
    {1, CT_MENU, INHERIT, NONE, "podpora"},
};

Table CT_MENU =
{
    {0, CT_NONE, INHERIT, NONE, "start"},
    {2, CT_CONFIG, INHERIT, NONE, "config"},
    {3, CT_ARROW, INHERIT, NONE, "arrow"},
    {4, CT_LOAD, INHERIT, NONE, "load"},
};

Table CT_CONFIG =
{
    {1, CT_NONE, INHERIT, NONE, "pomierzoneLevel"},
    {2, CT_NONE, INHERIT, NONE, "pierwotneLevel"},
};

Table CT_ARROW =
{
    {1, CT_NONE, INHERIT, NONE, "level"},
    {2, CT_NONE, INHERIT, NONE, "font"},
    {3, CT_NONE, INHERIT, NONE, "color"},
    {4, CT_NONE, INHERIT, NONE, "style"},
    {5, CT_NONE, INHERIT, NONE, "weight"},
    {6, CT_NONE, INHERIT, NONE, "textSize"},
    {7, CT_NONE, INHERIT, NONE, "maxLength"},
};

Table CT_LOAD =
{
    {1, CT_NONE, INHERIT, NONE, "config"},
    {2, CT_NONE, INHERIT, NONE, "pomierzone"},
};
