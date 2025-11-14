unit uOS_RestServer;

{$I mormot.defines.inc}
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
    fConnectionPool: TSqlDBOdbcConnectionProperties;
  public
    property ConnectionPool: TSqlDBOdbcConnectionProperties  read fConnectionPool;
  end;

implementation

end.
