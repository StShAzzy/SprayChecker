#include <sourcemod>
#include <tf2_stocks>

#include "cvarcheck/cvarquery.sp"

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0.1"

public Plugin myinfo = 
{
	name = "[TF2] Spray Checker",
	author = "Peanut",
	description = "Checks whether or not someone's cvars are set correctly so they display sprays",
	version = PLUGIN_VERSION,
	url = "https://discord.gg/7sRn8Bt"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion g_engineversion = GetEngineVersion();
	if (g_engineversion == Engine_Unknown)
	{
		PrintToServer("=======[Unknown Engine; Be Aware That This Might Work Properly!]=======");
		return APLRes_Success;
	}
	if (g_engineversion != Engine_TF2)
	{
		SetFailState("======[Not Running TF2, Stopping Plugin]======");
	}
	return APLRes_Success;
} 

public void OnPluginStart()
{
	CreateConVar("sm_spraychecking_version", PLUGIN_VERSION, "Holds Version", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	RegAdminCmd("sm_checkspray", CMDSprayChecking, ADMFLAG_GENERIC, "uso: sm_checkspray <alvo>");
	RegAdminCmd("sm_spraycheck", CMDSprayChecking, ADMFLAG_GENERIC, "uso: sm_spraycheck <alvo>");
	RegAdminCmd("sm_sprayerror", CMDSprayChecking, ADMFLAG_GENERIC, "uso: sm_sprayerror <alvo>");
	RegAdminCmd("sm_spraystatus", CMDSprayChecking, ADMFLAG_GENERIC, "uso: sm_spraystatus <alvo>");
	RegConsoleCmd("sm_spraycheckhelp", CMDSprayCheckHelp, "explica o que as siglas significam");
}

public Action CMDSprayCheckHelp(int client, int args)
{
	ReplyToCommand(client, "SD = cl_spraydisable \nSLT = r_spray_lifetime \nMPD = mp_decals \nRD = r_decals \nAD = cl_allowdownload \nAU = cl_allowupload");
	return Plugin_Handled;
}