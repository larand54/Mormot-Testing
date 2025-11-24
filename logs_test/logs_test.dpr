{
  Simplest test of mORMOT logging (and nothing else).
  See
  - https://blog.synopse.info/?post/2025/10/29/EKON-29-Slides
  - https://www.slideshare.net/slideshow/comprehensive-logging-with-mormot-2-on-delphi-and-fpc/283972772#1
}
{$IFDEF MSWINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF MSWINDOWS}


uses
  // {$if defined(FPC) and defined(UNIX)} CThreads, {$endif} // mormot.uses will do it
  SysUtils,
  mormot.core.log
  , mormot.core.base
  , mormot.core.rtti
;

type
  TMyClass = class
    procedure SomeMethod;
  end;

procedure TMyClass.SomeMethod;
var
  // Keep instance in variable, to make FPC hold it for longer.
  // Unfortunately you will get (correct)
  // Note: Local variable "log" is assigned but never used
  log: ISynLog;
begin
  try
    TSynLog.Add.Log(sllTrace, 'SomeMethod', self);
    TSynLog.Add.Log(sllError, 'SomeMethod error as %', ['messageError'], self);

    //log := TSynLog.Enter(self);
    TSynLog.EnterLocal(log, self, 'SomeMethod');
    if Assigned(log) then
      log.Log(sllTrace, 'SomeMethod log inside');

//    raise Exception.Create('test error');
  except
    on E: Exception do
      TSynLog.Add.Log(sllError, 'SomeMethod raised %', [E], self);
  end;
end;

var
  a: integer;
  error: string;
  my: TMyClass;

  LogFamily: TSynLogFamily;

begin
  LogFamily := TSynLog.Family;
  LogFamily.Level := LOG_VERBOSE;
  LogFamily.PerThreadLog := ptIdentifiedInOnFile;
  LogFamily.EchoToConsole := LOG_VERBOSE;

  a := 1;
  error := 'messageError';
  TSynLog.Add.Log(sllTrace,'Global a=%',[a]);
  TSynLog.Add.Log(sllError, 'Global error as %', [error]);
  my := TMyClass.Create;
  try
    my.SomeMethod;
  finally FreeAndNil(my) end;
  readln;
end.