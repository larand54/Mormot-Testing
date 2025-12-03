unit uOS_ServiceServer;
{$I mormot.defines.inc}

interface
uses
  {$I mormot.uses.inc}
  System.SysUtils
  ,  mormot.core.base
  ,  mormot.core.data
  ,  mormot.core.os
  ,  mormot.core.log
  ,  mormot.core.text
  ,  mormot.core.json
  ,  mormot.core.search
  ,  mormot.core.buffers
  ,  mormot.core.unicode
  ,  mormot.core.interfaces
  ,  mormot.orm.base
  ,  mormot.orm.core
  ,  mormot.soa.core
  ,  mormot.rest.core
  ,  mormot.rest.server
  ,  mormot.rest.memserver
  , mormot.rest.sqlite3
  , mormot.db.raw.sqlite3.static
;

type
  TRestServerLog = class(TSynLog)
  protected
    procedure ComputeFileName; override;
  end;

  TOSRestServer = class(TRestServerDB)
  public
    constructor Create; reintroduce;
  end;



implementation
uses
  OSModelServices
  , IOrderSystemInterfaces
  , uOrmOS_Data
;
{ TRestServerLog }

procedure TRestServerLog.ComputeFileName;
begin
  inherited ComputeFileName;
  FFileName := MakePath([ExtractFilePath(FFileName),
    StringReplace(ExtractFileName(FFileName), ' ', '_', [rfReplaceAll])]);
end;

{ TOSRestServer }

constructor TOSRestServer.Create;
var
  Model: TOrmModel;
begin
  model := createOSModel;
  inherited Create(Model, ChangeFileExt(Executable.ProgramFileName,'.db3'), false);

  // Logging class initialization
  SetLogClass(TRestServerLog);
  LogFamily.Level := LOG_VERBOSE;
  LogFamily.PerThreadLog := ptIdentifiedInOneFile;
  LogFamily.HighResolutionTimestamp := True;
  LogFamily.EchoToConsole := LOG_VERBOSE; // log all events to the console

  // Service registration  - Services is defined in unit OSModelServices. In this case we only have one service(IOrderSystem) defined.
  ServiceDefine(TOrderSystemService, [IOrderSystem], sicShared);

  Server.CreateMissingTables(0, [itoNoAutoCreateUsers]);  // You should always create your own users
end;

end.
