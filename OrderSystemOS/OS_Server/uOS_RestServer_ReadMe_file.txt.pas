unit uOS_RestServer_ReadMe_file.txt;

//Illustrate different parts of a Rest-Server
// They should be defined in different units
interface
uses
  {$I mormot.uses.inc}
  system.SysUtils
  , mormot.core.base
  , mormot.core.interfaces
  , mormot.core.threads
  , mormot.rest.memserver
  , mormot.db.sql.odbc               // TSqlDBOdbcConnectionProperties
  , mormot.db.sql                    // TSqlDBConnection
  , mormot.soa.server                // TInjectableObjectRest
;
// ---  Unit uRestServer -- Define your RestServer as follows:
type
  TMainRestServer = class(TRestServerFullMemory)
  strict private
    FConnectionPool: TSqlDBOdbcConnectionProperties;
  public
    property ConnectionPool: TSqlDBOdbcConnectionProperties
      read FConnectionPool;
  end;

// --- Unit  ICustomServices   -- Interface spec
  //  CustomService as follows:
type
  ICustomService = interface(IInvokable)
    function GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
  end;

// -- Unit uCustomServices -- Implementation of custom services
type
  TCustomServiceObject = class(TInjectableObjectRest, ICustomService)
  protected
    function GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
  end;
// !! -------------------------------------------------------------------------------------------!!

implementation

function TCustomServiceObject.GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
begin
  Result := False;
  if TMainRestServer(Server).ConnectionPool <> Nil then
  begin
    pmoConnection := TMainRestServer(Server).ConnectionPool.ThreadSafeConnection;
    Result := (pmoConnection <> Nil);
  end;
end;

  end;

//And use it in your services as follows:
  var
  json: RawUtf8;
  dbConn: TSqlDBConnection;
  dbStmt: ISqlDBStatement;
begin
  if GetConnection(dbConn) then
  begin
    dbStmt := dbConn.NewStatementPrepared(...);
    dbStmt.ExecutePreparedAndFetchAllAsJson(False, json);

end.
