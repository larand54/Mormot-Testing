unit uOS_RestServer;

{$I mormot.defines.inc}
interface
uses
{$I mormot.uses.inc}
  system.SysUtils
  , mormot.core.base
  , mormot.core.interfaces
  , mormot.core.log
  , mormot.core.text
  , mormot.core.threads
  , mormot.rest.memserver
  , mormot.rest.core
  , mormot.rest.server
  , mormot.db.sql.odbc               // TSqlDBOdbcConnectionProperties
  , mormot.db.sql                    // TSqlDBConnection
  , mormot.soa.server                // TInjectableObjectRest
;
// ---  Unit uRestServer -- Define your RestServer as follows:
type
  TCustomerItem = record
    CustomerNum: Integer;
    LoginUserName: RawUtf8;
    LoginPassword: RawUtf8;
  end;

  TCustomerItemArray = array of TCustomerItem;

  TFileAuthUser = class(TAuthUser)
  strict private
    FCustomerNum: Integer;
  published
    property CustomerNum: Integer
      read FCustomerNum write FCustomerNum;
  end;

  TRestServerLog = class(TSynLog)
  protected
    procedure ComputeFileName; override;
  end;

  TOS_RestServer = class(TRestServerFullMemory)
  strict private
    fConnectionPool: TSqlDBOdbcConnectionProperties;
  public
    constructor Create; reintroduce;
    property ConnectionPool: TSqlDBOdbcConnectionProperties  read fConnectionPool;
  end;
  var Log: ISynLog;

implementation
uses
  uOS_Data                       // TRecord-data(DTO:s)
  , uOrmOS_Data                  // Get model
  , mormot.orm.base
  , OSModelServices
  , IOrderSystemInterfaces
  , mormot.core.variants
  , mormot.soa.core
;
{ TRestServerLog }

procedure TRestServerLog.ComputeFileName;
begin
  inherited;
  inherited ComputeFileName;
  FFileName := MakePath([ExtractFilePath(FFileName),
    StringReplace(ExtractFileName(FFileName), ' ', '_', [rfReplaceAll])]);
end;


//==============================================================================
// TOS_RestServer
//==============================================================================

constructor TOS_RestServer.Create;
begin
  CreateWithOwnModel([TAuthGroup, TFileAuthUser,TOrmCustomer, TOrmProduct, TOrmOSOrder], {HandleUserAuthentication=} false, 'ordersystem');

  // Logging class initialization
  SetLogClass(TRestServerLog);
  LogFamily.Level := LOG_VERBOSE;
  LogFamily.PerThreadLog := ptIdentifiedInOneFile;
  LogFamily.HighResolutionTimestamp := True;

  // Service registration
  ServiceDefine(TOrderSystemService, [IOrderSystem], sicShared);

  Server.CreateMissingTables(0, [itoNoAutoCreateUsers]);  // You should always create your own users
  log.Log(sllInfo,'Server Started');
end;
initialization
end.
