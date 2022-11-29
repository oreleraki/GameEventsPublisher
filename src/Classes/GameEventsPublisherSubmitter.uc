class GameEventsPublisherSubmitter extends UBrowserBufferedTCPLink;

var bool      bIsConnected;

var String 		sHost;
var int 		  iHostPort;
var IpAddr    ipAddrServerIpAddr;
var String    sPasswordHeaderName;
var String    sPassword;
var String    sPath;
var String    sData;
var bool      Debug;

var GameEventsConfig Config;

function PostBeginPlay()
{
  Super.PostBeginPlay();
  Disable('Tick');
}

function OpenAndSend(String host, int port, String path, String passwordHeaderName, String password, String data, optional bool debug) {
  sHost = host;
  iHostPort = port;
  sPath = path;
  sPasswordHeaderName = passwordHeaderName;
  sPassword = password;
  sData = data;
  Debug = debug;

  ResetBuffer();
  Resolve(Host);
}

function Resolved(IpAddr Addr) {
  ipAddrServerIpAddr.Addr = Addr.Addr;
  ipAddrServerIpAddr.Port = iHostPort;

  Log("++ [GameEndPublisher]: Successfully resolved Server IP Address["$ipAddrServerIpAddr.Addr$"]");

  if (BindPort() == 0)
  {
    Log("++ [GameEndPublisher]: Failed to resolve port:"$ipAddrServerIpAddr.Port);
    return;
  }
  Open(ipAddrServerIpAddr);
}

function ResolveFailed() {
    Log("++ [GameEndPublisher]: Failed to resolve ip address:"$sHost);
}

function Disconnect()
{
  bIsConnected = FALSE;
  Close();
}

event Opened()
{
  Log("++ [GameEndPublisher]: Link is open.");
  GotoState('Submitting');
}

event Closed()
{
  Log("++ [GameEndPublisher]: Lost connection to server.");
}

// FUNCTION ProccessInput / Standard Processing Function
function ProcessInput(string Line)
{
  if (Debug) {
    Log("[Debug]" @ Line, Class.Name);
  }
}

function Tick(float DeltaTime)
{
  local string Line;

  DoBufferQueueIO();

  if (ReadBufferedLine(Line))
    ProcessInput(Line);
}


// States
auto state Created
{

Begin:

}

state Submitting
{
  function ProcessInput(string Line)
  {
    local bool IsError;
    local String ErrorMessage;

    // OK
    if (InStr(Line, "200") > 0)
    {
      IsError = false;
    }
    else
    {
      IsError = true;
      // Server Error
      if (InStr(Line, "500") > 0)
      {
        ErrorMessage = "Server Error";
      }
      // Unauthorized
      else if (InStr(Line, "401") > 0)
      {
        ErrorMessage = "Unauthorized";
      }
      else
      {
        ErrorMessage = Line;
        IsError = true;
      }
    }

    if (IsError)
    {
      Log("++ [GameEndPublisher]: Error! " $ ErrorMessage);
      Disconnect();
      return;
    }
    else {
      GotoState('Submitted');
    }

    Global.ProcessInput(Line);
  }

Begin:
    Log("++ [GameEndPublisher] Submitting:"@sData);
    SendBufferedData("POST /"$sPath$" HTTP/1.0" $ CR$LF);
	  SendBufferedData("User-Agent: Unreal" $ CR$LF);
	  SendBufferedData("Host:" @ sHost$":"$iHostPort$CR$LF);
	  SendBufferedData("Connection: close"$CR$LF);
	  SendBufferedData("Content-Type: application/json" $ CR$LF);
	  SendBufferedData("Content-Length:" @ Len(sData) $CR$LF);
    
    if (Len(sPassword) > 0)
    {
	    SendBufferedData(sPasswordHeaderName$":" @ sPassword $CR$LF);
    }
    SendBufferedData(CR$LF);
    SendBufferedData(sData);
}

state Submitted
{
  function ProcessInput(string Line)
  {
    Global.ProcessInput(Line);
  }

Begin:
    bIsConnected = true;
    Log("Successfully sent data to server.", Class.Name);
}
// EOF States