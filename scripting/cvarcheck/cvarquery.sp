int value1 = -1;
int value2 = -1;
int value3 = -1;
int value4 = -1;
int value5 = -1;
int value6 = -1;


Action SprayLifetime_Query(int target)
{
	QueryClientConVar(target, "r_spray_lifetime", OnCvarQueryFinished, value1);
	return value1;
}
Action SprayDisable_Query(int target)
{
	QueryClientConVar(target, "cl_spraydisable", OnCvarQueryFinished, value2);
	return value2;
}
Action MPDecals_Query(int target)
{
	QueryClientConVar(target, "mp_decals", OnCvarQueryFinished, value3);
	return value3;
}
Action RDecals_Query(int target)
{
	QueryClientConVar(target, "r_decals", OnCvarQueryFinished, value4);
	return value4;
}
Action AllowDownload_Query(int target)
{
	QueryClientConVar(target, "cl_allowdownload", OnCvarQueryFinished, value5);
	return value5;
}
Action AllowUpload_Query(int target)
{
	QueryClientConVar(target, "cl_allowupload", OnCvarQueryFinished, value6);
	return value6;
}


public Action CMDSprayChecking(int client, int args) {
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

  //char cvar[512];
  //GetCmdArg(2, cvar, sizeof(cvar));

  DataPack pack = new DataPack();

  if(client == 0) {
    pack.WriteCell(0);
  } else {
    pack.WriteCell(GetClientUserId(client));
  }

  pack.WriteCell(GetCmdReplySource());

  if(client == 0) {
    ReplyToCommand(client, "[SM] Consultando valor da cvar... OBS: caso você esteja utilizando uma ferramenta de RCON, você não verá o resultado");
  } else {
    ReplyToCommand(client, "[SM] Consultando valor da cvar...");
  }

  /*QueryClientConVar(target, "r_spray_lifetime", OnCvarQueryFinished, pack);
  QueryClientConVar(target, "cl_spraydisable", OnCvarQueryFinished, pack);
  QueryClientConVar(target, "mp_decals", OnCvarQueryFinished, pack);
  QueryClientConVar(target, "r_decals", OnCvarQueryFinished, pack);
  QueryClientConVar(target, "cl_allowdownload", OnCvarQueryFinished, pack);
  QueryClientConVar(target, "cl_allowupload", OnCvarQueryFinished, pack);
  */
  return Plugin_Handled;
}

public void OnCvarQueryFinished(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value) {
  DataPack pack = view_as<DataPack>(value);
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

  SetCmdReplySource(currentReplySource);
}
