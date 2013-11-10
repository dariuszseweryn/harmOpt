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
  DyspozytorskaRegulaHarmonogramowania, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    ADOConnection1: TADOConnection;
    Button2: TButton;
    Memo1: TMemo;
    Chart1: TChart;
    ChartTool1: TGanttTool;
    Series1: TGanttSeries;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    TabControl1: TTabControl;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    procedure Button2Click(Sender: TObject);
    procedure ChartTool1DragBar(Sender: TGanttTool; GanttBar: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Series1Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
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
  drhArray : array[1..9] of TDyspozytorskaRegulaHarmonogramowania;

implementation

{$R *.dfm}

procedure TForm1.harmonogramuj;
var
  zlecenie : TZlecenie;
  etapZlecenia : TZlecenieEtap;
  stanowisko : TStanowisko;
  drh : TDyspozytorskaRegulaHarmonogramowania;
begin
  if not (ComboBox1.ItemIndex = -1) then
  begin
    drh := ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TDyspozytorskaRegulaHarmonogramowania;

    Series1.Clear;
    if not (zlecenia = nil) then
    begin
      zlecenia.Free;
      stanowiska.Free;
    end;

    zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
    stanowiska := DBH.WyciagnijStanowiskaDoHarmonogramowania;

    zlecenia.Czysc;
    stanowiska.Czysc;

    Harmonogramator.Harmonogramuj(zlecenia, stanowiska, drh);
    print('Harmonogram dla reguly: ' + drh.NazwaReguly);
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
  for zlecenie in zlecenia do
  begin
    KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
    TabControl1.Tabs.Add(IntToStr(zlecenie.daneZlecenia.ID_ZLECENIA));
  end;
  self.TabControl1Change(TabControl1);

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

procedure TForm1.TabControl1Change(Sender: TObject);
var
  zlecenie : TZlecenie;
begin
  zlecenie := zlecenia.Items[TabControl1.TabIndex];
  Panel1.Color := KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('SELECT nr_etapu, id_rodzaje_stanowisk, id_stanowiska '+
                    'FROM zlec_technologie_etapy '+
                    'WHERE id_zlec_technologie = '+ IntToStr(zlecenie.daneZlecenia.ID_ZLEC_TECHNOLOGIE) + ' ' +
                    'ORDER BY nr_etapu asc');
  ADOQuery1.Open;
  DBGrid1.Columns.Items[0].ReadOnly := true;
  DBGrid1.Columns.Items[1].ReadOnly := true;
  DBGrid1.Columns.Items[2].ReadOnly := true;

end;

procedure TForm1.print(printString : String);
begin
  Memo1.Text := Memo1.Text + printString + #13#10;
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
var
  I: Integer;
begin
  DBH := TDataBaseHelper.Create(ADOConnection1);
  CH := TCzasHelper.Create(EncodeTime(8,0,0,0),EncodeTime(16,0,0,0));
  KH := TKolorHelper.Create;
  Harmonogramator := THarmonogramator.Create(CH);
  drhArray[1] := TDyspozytorskaRegulaHarmonogramowaniaSPTO.Create(CH);
  drhArray[2] := TDyspozytorskaRegulaHarmonogramowaniaSPTW.Create(CH);
  drhArray[3] := TDyspozytorskaRegulaHarmonogramowaniaEDDW.Create(CH);
  drhArray[4] := TDyspozytorskaRegulaHarmonogramowaniaMDD.Create(CH);
  drhArray[5] := TDyspozytorskaRegulaHarmonogramowaniaMST.Create(CH);
  drhArray[6] := TDyspozytorskaRegulaHarmonogramowaniaSCRW.Create(CH);
  drhArray[7] := TDyspozytorskaRegulaHarmonogramowaniaAOPN.Create(CH);
  drhArray[8] := TDyspozytorskaRegulaHarmonogramowaniaSOPN.Create(CH);
  drhArray[9] := TDyspozytorskaRegulaHarmonogramowania1ST.Create(CH);
  for I := 1 to Length(drhArray) do
  begin
    ComboBox1.AddItem(drhArray[I].NazwaReguly, drhArray[I]);
  end;
  ComboBox1.ItemIndex := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
//var
//  I: Integer;
begin
//  for I := 1 to Length(drhArray) do
//    drhArray[1].Free;
//  if not (DBH = nil) then DBH.Free;
//  if not (CH = nil) then CH.Free;
//  if not (zlecenia = nil) then zlecenia.Free;
//  if not (stanowiska = nil) then stanowiska.Free;
//  if not (Harmonogramator = nil) then Harmonogramator.Free;

//  DBH.Free;
end;

end.
