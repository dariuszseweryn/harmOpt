unit MainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Bde.DBTables, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.GanttCh, VCLTee.TeeGanttTool, VCLTee.TeeProcs,
  VCLTee.Chart, DataBaseHelper, Zlecenia, Zlecenie, ZlecenieEtap, Harmonogramator;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    ADOConnection1: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Chart1: TChart;
    ChartTool1: TGanttTool;
    Series1: TGanttSeries;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Series1Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    procedure harmonogramuj;

    //helpery
    procedure print(printString : String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 : TForm1;
  DBH : TDataBaseHelper;
  LastDraggedBarNumber : Integer = -1;

implementation

{$R *.dfm}

procedure TForm1.harmonogramuj;
var
  zlecenia : TZlecenia;
  zlecenie : TZlecenie;
  etapZlecenia : TZlecenieEtap;
begin
  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  for zlecenie in zlecenia do
  begin
    print('zlecenie' + #13#10);
    for etapZlecenia in zlecenie do
    begin
      if not (etapZlecenia.poprzedniEtap = nil) then
        print('poprzedniEtap->NR_ETAPU ' + IntToStr(etapZlecenia.poprzedniEtap.NR_ETAPU));
      if not (etapZlecenia.nastepnyEtap = nil) then
        print('nastepnyEtap->NR_ETAPU ' + IntToStr(etapZlecenia.nastepnyEtap.NR_ETAPU));

      print('ID_ZLECENIA ' + IntToStr(etapZlecenia.daneZlecenia.ID_ZLECENIA) + ' ' +
            'ID_ZLEC_TECHNOLOGIE ' + IntToStr(etapZlecenia.daneZlecenia.ID_ZLEC_TECHNOLOGIE) + ' ' +
            'ILOSC_ZLECONA ' + IntToStr(etapZlecenia.daneZlecenia.ILOSC_ZLECONA) + ' ' +
            'NR_ETAPU ' + IntToStr(etapZlecenia.NR_ETAPU) + ' ' +
            'TPZ_M ' + IntToStr(etapZlecenia.TPZ_M) + ' ' +
            'TJ_M ' + IntToStr(etapZlecenia.TJ_M) + ' ' +
            'ID_STANOWISKA ' + IntToStr(etapZlecenia.ID_STANOWISKA) + ' ' +
            'ID_RODZAJE_STANOWISK ' + IntToStr(etapZlecenia.ID_RODZAJE_STANOWISK));
    end;
  end;
  zlecenia.Free;
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

procedure TForm1.Button1Click(Sender: TObject);
var
  Task1 : Integer;
  Task2 : Integer;
begin
  Task1 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,0,0,0), EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), 0, 'raz');
  print(IntToStr(Task1));
  Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(13,0,0,0), 0, 'raz');
  Task2 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(15,0,0,0), 1, 'dwa');
  Series1.NextTask[Task1] := Task2;
  Chart1.AddSeries(Series1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  harmonogramuj;
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
  Chart1.Zoom.Allow := not(CheckBox1.Checked);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DBH := TDataBaseHelper.HelperWithConnection(ADOConnection1);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  DBH.Free;
end;

end.
