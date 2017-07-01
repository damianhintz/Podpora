/* 
 * File:   cmd.h
 * Author: damian
 *
 * Created on 27 sierpnia 2016, 20:54
 */

#ifndef CMD_H
#define CMD_H
#include <ditemlib.fdf>
#include <mdllib.fdf>
#include <mssystem.fdf>
#include <string.h>
#include <msstring.fdf>
#include <mscell.fdf>
#include <msinput.fdf>
#include <msreffil.fdf>
#include <cmdlist.h>
#include <msdialog.fdf>
#include <msparse.fdf>
#include "app.h"
#include "fenceReader.h"
#include "arrowBuilder.h"
#include "ui.h"
#include "ui-cmd.h"
#include "core\podporaSkaner.h"

int command_loadPomierzone();
void command_loadConfig();
void command_configPomierzoneLevel(int pomierzoneLevel);
void command_configPierwotneLevel(int pierwotneLevel);
void command_arrowLevel(int level);
void command_arrowFont(int font);
void command_arrowColor(int color);
void command_arrowStyle(int style);
void command_arrowWeight(int weight);
void command_arrowTextSize(double size);
void command_arrowMaxLength(double length);

#endif /* CMD_H */

