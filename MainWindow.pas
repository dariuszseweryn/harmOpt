unit MainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Bde.DBTables, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.GanttCh, VCLTee.TeeGanttTool, VCLTee.TeeProcs,
  VCLTee.Chart;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    ADOConnection1: TADOConnection;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    ADODataSet2: TADODataSet;
    Button1: TButton;
    Button2: TButton;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    Memo1: TMemo;
    Button3: TButton;
    Chart1: TChart;
    ChartTool1: TGanttTool;
    Series1: TGanttSeries;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Series1Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
  private
  type
    TZlecenie = record
      ID_ZLEC_TECHNOLOGIE : Integer;
      ILOSC_ZLECONA : Integer;
    end;

    TEtapZlecenia = record
      TPZ_M : Integer;
      TJ_M : Integer;
      ID_STANOWISKA : Integer;
      ID_RODZAJE_STANOWISK : Integer;
    end;
    TZlecenia = Array of TZlecenie;
    TEtapyZlecenia = Array of TEtapZlecenia;

    procedure harmonogramuj;
    function wyciagnijZlecenia : TZlecenia;
    function wyciagnijEtapy(ID_ZLEC_TECHNOLOGIE : Integer) : TEtapyZlecenia;
    function obliczCzasEtapu(TPZ_M : Integer;
                        TJ_M : Integer;
               iloscZlecenia : Integer) : Integer;
    procedure zajmijStanowisko(ID_STANOWISKA : Integer;
                                   czasEtapu : Integer);

    //helpery
    procedure print(printString : String);
    procedure printZlecenia(zlecenia : TZlecenia);
    procedure printEtapyZlecenia(etapyZlecenia : TEtapyZlecenia);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 : TForm1;
  MyString : string;
  MyArray : Array of Integer;
  LastDraggedBarNumber : Integer = -1;

implementation

{$R *.dfm}

function StringFromArray(A: Array of Integer) : String;
var
  I: Integer;
  ReturnString: string;
begin
  for I in A do
  begin
    ReturnString := ReturnString + ' ' + IntToStr(I);
  end;
  Result := ReturnString;
end;

procedure SortArray(var A: Array of Integer);
var
  I, J, X: Integer;
begin
  if Length(A) > 1 then
  begin
    for I := 0 to Length(A) - 1 do
    begin
      for J := 1 to Length(A) - I do
      begin
        if A[J - 1] > A[J] then
        begin
          X := A[J - 1];
          A[J - 1] := A[J];
          A[J] := X;
        end;
      end;
    end;
  end;
end;

procedure TForm1.harmonogramuj;
var
  mojeZlecenia : TZlecenia;
  mojeEtapyZlecenia : TEtapyZlecenia;
  zlecenie : TZlecenie;
  czasEtapu : Integer;
begin
  mojeZlecenia := wyciagnijZlecenia();
  printZlecenia(mojeZlecenia);
  for zlecenie in mojeZlecenia do
  begin
    mojeEtapyZlecenia := wyciagnijEtapy(zlecenie.ID_ZLEC_TECHNOLOGIE);
    printEtapyZlecenia(mojeEtapyZlecenia);
//    for etapZlecenia in etapyZlecenia do
//    begin
//      czasEtapu := obliczCzasEtapu(etapZlecenia.TPZ_M, etapZlecenia.TJ_M, zlecenie.iloscZlecenia);
//      zajmijStanowisko(etapZlecenia.ID_STANOWISKA, czasEtapu);
//    end;
  end;
end;

function TForm1.wyciagnijZlecenia() : TZlecenia;
var
  Query : TADOQuery;
  mojeZlecenia : TZlecenia;
  mojeZleceniePtr : ^TZlecenie;
begin
  Query := TADOQuery.Create(nil);
  Query.Connection := ADOConnection1;
  Query.SQL.Add('SELECT * '+
                'FROM zlecenia '+
                'WHERE status = ''wystawione'' '+
                'ORDER BY rok asc, miesiac asc');
  Query.Open;

  while not Query.Eof do
  begin
    New(mojeZleceniePtr); // nowy record

    SetLength(mojeZlecenia, Length(mojeZlecenia) + 1); // zwiekszamy rozmiar tablicy

    mojeZleceniePtr.ID_ZLEC_TECHNOLOGIE := Query.FieldByName('ID_ZLEC_TECHNOLOGIE').AsInteger; // ustawianie rekordu
    mojeZleceniePtr.ILOSC_ZLECONA := Query.FieldByName('ILOSC_ZLECONA').AsInteger;

    mojeZlecenia[Length(mojeZlecenia) - 1] := mojeZleceniePtr^; // na ostatnim miejscu wrzucamy nowy rekord

    Dispose(mojeZleceniePtr); // pozbywamy sie pointera do utworzonego recordu

    Query.Next;
  end;

  Query.Destroy;
  Result := mojeZlecenia;
end;

procedure TForm1.printEtapyZlecenia(etapyZlecenia : TEtapyZlecenia);
var
  etapZlecenia : TEtapZlecenia;
begin
  print(#13#10 + '=sprawdzenie etapów zlecenia=');
  for etapZlecenia in etapyZlecenia do
  begin
    print(format('TPZ_M = %d ; TJ_M = %d ; ID_STANOWISKA = %d ; ID_RODZAJE_STANOWISK = %d',
      [etapZlecenia.TPZ_M,
       etapZlecenia.TJ_M,
       etapZlecenia.ID_STANOWISKA,
       etapZlecenia.ID_RODZAJE_STANOWISK]));
  end;
end;

procedure TForm1.printZlecenia(zlecenia : TZlecenia);
var
  zlecenie : TZlecenie;
begin
  print(#13#10 + '=sprawdzenie zleceñ=');
  for zlecenie in zlecenia do
  begin
    print(format('ID_ZLEC_TECHNOLOGIE = %d ; ILOSC_ZLECONA = %d',
      [zlecenie.ID_ZLEC_TECHNOLOGIE,
       zlecenie.ILOSC_ZLECONA]));
  end;
end;

procedure TForm1.Series1Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Memo1.Text := 'clicked ' + IntToStr(ValueIndex);
end;

procedure TForm1.print(printString : String);
begin
  Memo1.Text := Memo1.Text + printString + #13#10;
end;

function TForm1.wyciagnijEtapy(ID_ZLEC_TECHNOLOGIE : Integer) : TEtapyZlecenia;
var
  Query : TADOQuery;
  mojeEtapyZlecenia : TEtapyZlecenia;
  mojEtapZleceniaPtr : ^TEtapZlecenia;
begin
  Query := TADOQuery.Create(nil);
  Query.Connection := ADOConnection1;
  Query.SQL.Add('SELECT * '+
                'FROM zlec_technologie_etapy '+
                'WHERE id_zlec_technologie = '+ IntToStr(ID_ZLEC_TECHNOLOGIE) + ' ' +
                'ORDER BY nr_etapu asc');
  Query.Open;

  while not Query.Eof do
  begin
    New(mojEtapZleceniaPtr); // nowy record

    SetLength(mojeEtapyZlecenia, Length(mojeEtapyZlecenia) + 1); // zwiekszamy rozmiar tablicy

    mojEtapZleceniaPtr.TPZ_M := Query.FieldByName('TPZ_M').AsInteger; // ustawianie rekordu
    mojEtapZleceniaPtr.TJ_M := Query.FieldByName('TJ_M').AsInteger;
    mojEtapZleceniaPtr.ID_STANOWISKA := Query.FieldByName('ID_STANOWISKA').AsInteger;
    mojEtapZleceniaPtr.ID_RODZAJE_STANOWISK := Query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;

    mojeEtapyZlecenia[Length(mojeEtapyZlecenia) - 1] := mojEtapZleceniaPtr^; // na ostatnim miejscu wrzucamy nowy rekord

    Dispose(mojEtapZleceniaPtr); // pozbywamy sie pointera do utworzonego recordu

    Query.Next;
  end;

  Query.Destroy;
  Result := mojeEtapyZlecenia;
end;

function TForm1.obliczCzasEtapu(TPZ_M : Integer; TJ_M : Integer; iloscZlecenia : Integer) : Integer;
begin
  Result := TPZ_M + TJ_M * iloscZlecenia;
end;

procedure TForm1.zajmijStanowisko(ID_STANOWISKA : Integer; czasEtapu : Integer);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Task1 : Integer;
  Task2 : Integer;
  SeriesGantt : TGanttSeries;
  ChartTool : TGanttTool;
begin
  SeriesGantt := TGanttSeries.Create(nil);
  SeriesGantt.LineHeight := 20;
  ChartTool := TGanttTool.Create(nil);
  ChartTool.AllowDrag := True;
//  ChartTool.Series := Series1;
  Task1 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,0,0,0), EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), 0, 'raz');
  Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(13,0,0,0), 0, 'raz');
  Task2 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(15,0,0,0), 1, 'dwa');
  Series1.NextTask[Task1] := Task2;
  Chart1.AddSeries(Series1);
//  Chart1.Tools.Add(ChartTool);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  harmonogramuj;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ADOQuery1.SQL.Add('SELECT * FROM ZLEC_TECHNOLOGIE order by kod_technologii asc');
  ADOQuery1.Open;
  while not AdoQuery1.eof do
  begin
    Memo1.Text := Memo1.Text + format('%s %s %s',
      [ADOQuery1.FieldByname('KOD_TECHNOLOGII').AsString,
        ADOQuery1.FieldByname('NAZ_TECHNOLOGII').AsString,
        ADOQuery1.FieldByname('DATE').AsString]) + #13#10;
    ADOQuery1.Next;
  end;

end;

procedure TForm1.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if LastDraggedBarNumber >= 0 then
  begin
    Memo1.Text := 'Last Dragged Bar #' + IntToStr(LastDraggedBarNumber);
    LastDraggedBarNumber := -1;
  end;
end;

procedure TForm1.ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
begin
  LastDraggedBarNumber := GanttBar;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ChartTool1.AllowDrag := CheckBox1.Checked;
end;

end.
