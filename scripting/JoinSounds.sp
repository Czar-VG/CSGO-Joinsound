#pragma semicolon 1

#define PLUGIN_AUTHOR "Czar"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

Handle Cvar_filepath;
char song[512];
public Plugin myinfo = 
{
	name = "Join Sounds",
	author = PLUGIN_AUTHOR,
	description = "Plays a specified sound when a player joins server",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	Cvar_filepath = CreateConVar("sm_joinsound", "czar/joinsound/joinsound.mp3", "set the full path to joinsound.mp3 file");
	GetConVarString(Cvar_filepath, song, sizeof(song));
	
	RegConsoleCmd("sm_soundtest", cmd_test);
}

public void OnMapStart()
{
	char soundname[512];
	PrecacheSound(song, true);
	Format(soundname, sizeof(soundname), "sound/%s", song);
	AddFileToDownloadsTable(soundname);
}

public void  OnClientPutInServer(int client)
{
	CreateTimer(5.0, Timer_Sound, client);
}

public Action Timer_Sound(Handle timer, int client)
{
	if (IsClientInGame(client))
	{
		playjoinsound(client);
	}
	else if (IsClientConnected(client))
	{
		CreateTimer(5.0, Timer_Sound, client);
	}
}

public Action cmd_test(int client, int args)
{
	playjoinsound(client);
}

public void playjoinsound(int client)
{
	ClientCommand(client, "playgamesound Music.StopAllMusic");
	ClientCommand(client, "play \"*%s\"", song);
}
