unit MainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Bde.DBTables, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.GanttCh, VCLTee.TeeGanttTool, VCLTee.TeeProcs,
  VCLTee.Chart, DataBaseHelper, Zlecenia, Zlecenie, ZlecenieEtap, Harmonogramator, CzasHelper, Stanowiska, Stanowisko, KolorHelper, System.DateUtils,
  DyspozytorskaRegulaHarmonogramowaniaSPTO, DyspozytorskaRegulaHarmonogramowaniaSPTW, DyspozytorskaRegulaHarmonogramowaniaEDDW, DyspozytorskaRegulaHarmonogramowaniaMDD, DyspozytorskaRegulaHarmonogramowaniaMST,
  DyspozytorskaRegulaHarmonogramowaniaSCRW, DyspozytorskaRegulaHarmonogramowaniaAOPN, DyspozytorskaRegulaHarmonogramowaniaSOPN, DyspozytorskaRegulaHarmonogramowania1ST,
  DyspozytorskaRegulaHarmonogramowania;

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

    zlecenia : TZlecenia;
    stanowiska : TStanowiska;

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
  CH : TCzasHelper;
  KH : TKolorHelper;
  Harmonogramator : THarmonogramator;
  LastDraggedBarNumber : Integer = -1;

implementation

{$R *.dfm}

procedure TForm1.harmonogramuj;
var
  zlecenie : TZlecenie;
  etapZlecenia : TZlecenieEtap;
  stanowisko : TStanowisko;
  start, stop, tempTime : TDateTime;
  h, m, s, ms : Word;
  I, J: Integer;
  drhArray : array[1..1] of TDyspozytorskaRegulaHarmonogramowania;
  drh : TDyspozytorskaRegulaHarmonogramowania;
begin
//  drhArray[1] := TDyspozytorskaRegulaHarmonogramowaniaSPTO.Create(CH);
  drhArray[1] := TDyspozytorskaRegulaHarmonogramowaniaSPTW.Create(CH);
//  drhArray[2] := TDyspozytorskaRegulaHarmonogramowaniaEDDW.Create(CH);
//  drhArray[3] := TDyspozytorskaRegulaHarmonogramowaniaMDD.Create(CH);
//  drhArray[1] := TDyspozytorskaRegulaHarmonogramowaniaMST.Create(CH);
//  drhArray[5] := TDyspozytorskaRegulaHarmonogramowaniaSCRW.Create(CH);
//  drhArray[6] := TDyspozytorskaRegulaHarmonogramowaniaAOPN.Create(CH);
//  drhArray[7] := TDyspozytorskaRegulaHarmonogramowaniaSOPN.Create(CH);
//  drhArray[8] := TDyspozytorskaRegulaHarmonogramowania1ST.Create(CH);

  Series1.Clear;
  if not (zlecenia = nil) then
  begin
    zlecenia.Free;
    stanowiska.Free;
  end;

  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  stanowiska := DBH.WyciagnijStanowiskaDoHarmonogramowania;

  for J := 1 to Length(drhArray) do
  begin
    drh := drhArray[J];
    tempTime := 0;
    for I := 0 to 1 do
    begin
      zlecenia.Czysc;
      stanowiska.Czysc;

      start := Now;
      Harmonogramator.Harmonogramuj(zlecenia, stanowiska, drh);
      stop := Now;

      tempTime := tempTime + (stop - start);
    end;
    DecodeTime(TimeOf(tempTime),h,m,s,ms);
    print('Czas Harmonogramowania dla reguly ' + drh.NazwaReguly + ' = ' +
          IntToStr(h) + 'h ' + IntToStr(m) + 'm ' +
          IntToStr(s) + 's ' + IntToStr(ms) + 'ms');
    drh.Free;
  end;

//  for zlecenie in zlecenia do
//  begin
//    print(#13#10 + '====== zlecenie ======');
//    print('ID_ZLECENIA ' + IntToStr(zlecenie.daneZlecenia.ID_ZLECENIA) + ' ' +
//          'ID_ZLEC_TECHNOLOGIE ' + IntToStr(zlecenie.daneZlecenia.ID_ZLEC_TECHNOLOGIE) + ' ' +
//          'ILOSC_ZLECONA ' + IntToStr(zlecenie.daneZlecenia.ILOSC_ZLECONA) + #13#10 +
//          'PLAN_DATA_ROZPOCZECIA ' + DateTimeToStr(zlecenie.daneZlecenia.PLAN_DATA_ROZPOCZECIA) + ' ' +
//          'PLAN_TERMIN_REALIZACJI ' + DateTimeToStr(zlecenie.daneZlecenia.PLAN_TERMIN_REALIZACJI));
//    print('====== etapy ======');
//    for etapZlecenia in zlecenie do
//    begin
//      print('NR_ETAPU ' + IntToStr(etapZlecenia.NR_ETAPU) + ' ' +
//            'TPZ_M ' + IntToStr(etapZlecenia.TPZ_M) + ' ' +
//            'TJ_M ' + IntToStr(etapZlecenia.TJ_M) + ' ' +
//            'ID_STANOWISKA ' + IntToStr(etapZlecenia.ID_STANOWISKA) + ' ' +
//            'ID_RODZAJE_STANOWISK ' + IntToStr(etapZlecenia.ID_RODZAJE_STANOWISK) + ' ' +
//            'czas trwania ' + IntToStr(etapZlecenia.CzasWykonaniaNetto));
//    end;
//  end;
  for zlecenie in zlecenia do KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);

  for stanowisko in stanowiska do
  begin
    for etapZlecenia in stanowisko.listaEtapow do
    begin
      etapZlecenia.ganttID := Series1.AddGanttColor(etapZlecenia.DATA_START,
                                                    etapZlecenia.DATA_KONIEC,
                                                    stanowiska.IndexOf(stanowisko),
                                                    stanowisko.NAZ_STANOWISKA,
                                                    KH.KolorDlaId(etapZlecenia.daneZlecenia.ID_ZLECENIA));
    end;
  end;

  zlecenia.PolaczKolejneEtapyZlecenWSerii(Series1);

end;

procedure TForm1.Series1Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  kliknietyEtapZlecenia, pierwszyEtap, ostatniEtap : TZlecenieEtap;
begin
  Memo1.Text := 'clicked ' + IntToStr(ValueIndex) + #13#10;
  kliknietyEtapZlecenia := zlecenia.ZnajdzEtapZleceniaZGanttId(ValueIndex);
  if not (kliknietyEtapZlecenia = nil) then
  begin
    print('======= ZLECENIE =======');
    print('ID_ZLECENIA ' + IntToStr(kliknietyEtapZlecenia.daneZlecenia.ID_ZLECENIA));
    print('Rozpoczecie ' + DateTimeToStr(kliknietyEtapZlecenia.daneZlecenia.PLAN_DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(kliknietyEtapZlecenia.daneZlecenia.PLAN_TERMIN_REALIZACJI));
    print('==== ETAP ZLECENIA =====');
    print('NR_ETAPU ' + IntToStr(kliknietyEtapZlecenia.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_START));
    print('Zakonczenie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_KONIEC));
    print('==== PIERWSZY ETAP =====');
    pierwszyEtap := kliknietyEtapZlecenia.PierwszyEtap;
    print('NR_ETAPU ' + IntToStr(pierwszyEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(pierwszyEtap.DATA_START));
    print('Zakonczenie ' + DateTimeToStr(pierwszyEtap.DATA_KONIEC));
    print('===== OSTATNI ETAP =====');
    ostatniEtap := kliknietyEtapZlecenia.OstatniEtap;
    print('NR_ETAPU ' + IntToStr(ostatniEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(ostatniEtap.DATA_START));
    print('Zakonczenie ' + DateTimeToStr(ostatniEtap.DATA_KONIEC));
  end;
end;

procedure TForm1.print(printString : String);
begin
  Memo1.Text := Memo1.Text + printString + #13#10;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Task1 : Integer;
  Task2 : Integer;
  data1 : TDateTime;
  data2 : TDateTime;
begin
//  Task1 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,0,0,0), EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), 0, 'raz');
//  print(IntToStr(Task1));
//  Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(13,0,0,0), 0, 'raz');
//  Task2 := Series1.AddGantt(EncodeDate(2013,3,1)+EncodeTime(12,30,0,0), EncodeDate(2013,3,1)+EncodeTime(15,0,0,0), 1, 'dwa');
//  Series1.NextTask[Task1] := Task2;
//  Chart1.AddSeries(Series1);
  data1 := EncodeDate(2013,4,19) + EncodeTime(8,0,0,0);
  print(DateTimeToStr(data1));
  data2 := CH.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(data1, 961);
  print(DateTimeToStr(data2));
  data1 := CH.DataCzasRozpoczeciaDlaDatyCzasuZakonczeniaICzasuTrwania(data2, 961);
  print(DateTimeToStr(data1));
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
  DBH := TDataBaseHelper.Create(ADOConnection1);
  CH := TCzasHelper.Create(EncodeTime(8,0,0,0),EncodeTime(16,0,0,0));
  KH := TKolorHelper.Create;
  Harmonogramator := THarmonogramator.Create(CH);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  if not (DBH = nil) then DBH.Free;
//  if not (CH = nil) then CH.Free;
//  if not (zlecenia = nil) then zlecenia.Free;
//  if not (stanowiska = nil) then stanowiska.Free;
//  if not (Harmonogramator = nil) then Harmonogramator.Free;

//  DBH.Free;
end;

end.
