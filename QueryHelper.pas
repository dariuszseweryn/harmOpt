unit QueryHelper;

interface

uses
  Data.Win.ADODB;

type
  TQueryHelper = class

  public
    Query : TADOQuery;

    constructor HelperWithConnection(connection : TADOConnection);
//    destructor Free;

    function fetchQuery(sqlString : String) : TADOQuery;
    procedure executeQuery(sqlString : String);
  end;

implementation

  constructor TQueryHelper.HelperWithConnection(connection : TADOConnection);
  begin
    Query := TADOQuery.Create(connection);
    Query.Connection := connection;
  end;

//  destructor TQueryHelper.Free;
//  begin
//    if Query.Active then Query.Close;
//    Query.Free;
//  end;

  function TQueryHelper.fetchQuery(sqlString : String) : TADOQuery;
  begin
    if Query.Active then Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add(sqlString);
    Query.Open;
    Result := Query;
  end;

  procedure TQueryHelper.executeQuery(sqlString : String);
  begin
    if Query.Active then Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add(sqlString);
    Query.ExecSQL;
  end;

end.
