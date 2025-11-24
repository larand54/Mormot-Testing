program OrderSystemOS_Server;

{$I mormot.defines.inc}

{$IFDEF MSWINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF MSWINDOWS}

uses
  {$I mormot.uses.inc}
  System.SysUtils,
  mormot.core.base,
  mormot.core.data,
  mormot.core.os,
  mormot.core.text,
  mormot.core.json,
  mormot.core.search,
  mormot.core.buffers,
  mormot.core.unicode,
  mormot.rest.core,
  mormot.rest.http.server,
  IOrderSystemInterfaces in 'IOrderSystemInterfaces.pas',
  uOS_Data in 'uOS_Data.pas',
  uOrmOS_Data in 'uOrmOS_Data.pas',
  uOS_ServiceServer in 'uOS_ServiceServer.pas',
  OSModelServices in 'OSModelServices.pas';

type
  TTestServerMain = class(TSynPersistent)
//==============================================================================
// TTestServerMain
//==============================================================================

  strict private
    FCustomerConfigFile: TFileName;
  private
    FHttpServer: TRestHttpServer;
    FRestServer: TOSRestServer;
  public
    constructor Create(const pmcCustomerConfigFileName: TFileName; const pmcDataFolder: TFileName); reintroduce;
    destructor Destroy; override;
    function RunServer(const pmcPort: RawUtf8): Boolean;
  end;

constructor TTestServerMain.create(const pmcCustomerConfigFileName: TFileName; const pmcDataFolder: TFileName);
begin
  inherited Create;
  FRestServer := TOSRestServer.Create;
  FCustomerConfigFile := pmcCustomerConfigFileName;
  if ExtractFilePath(FCustomerConfigFile) = '' then
    FCustomerConfigFile := MakePath([Executable.ProgramFilePath, FCustomerConfigFile]);
end;


destructor TTestServerMain.Destroy;
begin
  FreeAndNil(FHttpServer);
  FRestServer.Free;
  inherited Destroy;
end;


function TTestServerMain.RunServer(const pmcPort: RawUtf8): Boolean;
begin
  Result := False;
  if (FHttpServer = Nil) then
  begin
    FHttpServer := TRestHttpServer.Create(pmcPort, [FRestServer], 'OS', useHttpSocket {or useHttpAsync});
    FHttpServer.AccessControlAllowOrigin := '*';
    Result := True;
  end;
end;


//==============================================================================
var
  MainServer: TTestServerMain;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  AuthUserGroupDefaultTimeout := 60 * 10;  // 10 minutes

  MainServer := TTestServerMain.Create('Customer.config', Executable.ProgramFilePath);
  try
    try
      if MainServer.RunServer('8080') then
        WriteLn('Press [Enter] to quit server...')
      else
        WriteLn('Something went wrong...');
    except
      on E: Exception do
      begin
        ConsoleShowFatalException(E, True);
        ExitCode := 1;
      end;
    end;

    ConsoleWaitForEnterKey;
  finally
    MainServer.Free;
  end;

end.
