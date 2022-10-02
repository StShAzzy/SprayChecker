//#define DEBUG
int value1 = -1;
int value2 = -1;
int value3 = -1;
int value4 = -1;
int value5 = -1;
int value6 = -1;


stock SprayDisable_Query(int target)
{
	value1 = -1;
	QueryClientConVar(target, "cl_spraydisable", OnCvarQueryFinished, value1);
	return value1;
}
stock SprayLifetime_Query(int target)
{
	value2 = -1;
	QueryClientConVar(target, "r_spray_lifetime", OnCvarQueryFinished, value2);
	return value2;
}
stock MPDecals_Query(int target)
{
	value3 = -1;
	QueryClientConVar(target, "mp_decals", OnCvarQueryFinished, value3);
	return value3;
}
stock RDecals_Query(int target)
{
	value4 = -1;
	QueryClientConVar(target, "r_decals", OnCvarQueryFinished, value4);
	return value4;
}
stock AllowDownload_Query(int target)
{
	value5 = -1;
	QueryClientConVar(target, "cl_allowdownload", OnCvarQueryFinished, value5);
	return value5;
}
stock AllowUpload_Query(int target)
{
	value6 = -1;
	QueryClientConVar(target, "cl_allowupload", OnCvarQueryFinished, value6);
	return value6;
}


public Action CMDSprayChecking(int client, int args) 
{
	if(args < 1) {
    ReplyToCommand(client, "[SM] Comando so espera por um alvo, e nenhum outro argumento!");
    return Plugin_Handled;
	}

	char targetArg[MAX_TARGET_LENGTH];
	GetCmdArg(1, targetArg, sizeof(targetArg));

	int target = FindTarget(client, targetArg, true);
	if(target == -1) {
    return Plugin_Handled;
	}
	#if defined DEBUG
	PrintToChatAll("[DEBUG] Target: %d", target);
	PrintToChatAll("[DEBUG] Client: %d", client);
	#endif
  	/*
  	//char cvar[512];
  	//GetCmdArg(2, cvar, sizeof(cvar));

	DataPack pack = new DataPack();

	if(client == 0) 
	{
	pack.WriteCell(0);
  	} 
  	else 
  	{
    pack.WriteCell(GetClientUserId(client));
	}

 	pack.WriteCell(GetCmdReplySource());*/
	
	if(client == 0) 
	{
    	ReplyToCommand(client, "[SM] Consultando valor da cvar... OBS: caso você esteja utilizando uma ferramenta de RCON, você não verá o resultado");
  	} 
  	else 
  	{
    	ReplyToCommand(client, "[SM] Consultando valor da cvar...");
	}
	SprayDisable_Query(target);
	SprayLifetime_Query(target);
	MPDecals_Query(target);
	RDecals_Query(target);
	AllowDownload_Query(target);
	AllowUpload_Query(target);
	CreateTimer(1.5, TextPrinter, client);
	#if defined DEBUG
	PrintToChatAll("[DEBUG] Timer Criado");
	#endif
	return Plugin_Handled;
}

public void OnCvarQueryFinished(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value) 
{
  /*DataPack pack = view_as<DataPack>(value);
  pack.Reset();

  int userid = pack.ReadCell();

  int executor;

  if(userid == 0) {
    executor = 0;
  } else {
    executor = GetClientOfUserId(userid);

    if(executor <= 0) {
      delete pack;
      return;
    }
  }

  ReplySource clientReplySource = view_as<ReplySource>(pack.ReadCell());

  delete pack;

  ReplySource currentReplySource = GetCmdReplySource();

  SetCmdReplySource(clientReplySource);

  switch(result) {
    case ConVarQuery_Okay: {
      ReplyToCommand(executor, "[SM] Valor da cvar %s para o jogador %N: %s", cvarName, client, cvarValue);
    }
    case ConVarQuery_NotFound: {
      ReplyToCommand(executor, "[SM] Cvar não encontrada: %s", cvarName);
    }
    case ConVarQuery_NotValid: {
      ReplyToCommand(executor, "[SM] Cvar inválida: %s", cvarName);
    }
    case ConVarQuery_Protected: {
      ReplyToCommand(executor, "[SM] Não é possível ler o valor da cvar %s pois ela é protegida", cvarName);
    }
  }

  SetCmdReplySource(currentReplySource);*/
	
	if (StrEqual(cvarName, "cl_spraydisable"))
	{
		value1 = StringToInt(cvarValue); 	
	}
	if (StrEqual(cvarName, "r_spray_lifetime"))
	{
		value2 = StringToInt(cvarValue);
	}
	if (StrEqual(cvarName, "mp_decals"))
	{
		value3 = StringToInt(cvarValue);
	}
	if (StrEqual(cvarName, "r_decals"))
	{
		value4 = StringToInt(cvarValue);
	}
	if (StrEqual(cvarName, "cl_allowdownload"))
	{
		value5 = StringToInt(cvarValue);
	}
	if (StrEqual(cvarName, "cl_allowupload"))
	{
		value6 = StringToInt(cvarValue);
	}
	//PrintToChatAll("SD:%d, SLT:%d, MPD:%d, RD:%d, AD:%d, AU:%d", value1, value2, value3, value4, value5, value6);
}

	Action TextPrinter(Handle time ,int client)
	{
		#if defined DEBUG
		PrintToChatAll("[DEBUG] Timer Executado");
		#endif
		PrintHintText(client, "SD:%d, SLT:%d, MPD:%d, RD:%d, AD:%d, AU:%d", value1, value2, value3, value4, value5, value6);
		return Plugin_Stop;
	}
