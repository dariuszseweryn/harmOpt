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
    StringGrid1: TStringGrid;
    SaveToDBButton: TButton;
    LoadFromDBButton: TButton;
    ListBox1: TListBox;
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
    procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
    procedure PrzydzielEtapyDoStanowisk;
    procedure NaniesEtapyZeStanowiskNaWykres;
    procedure ZbudujKoloryITaby;
    function ZaznaczonyEtapWTabeli : TZlecenieEtap;
    procedure SaveToDBButtonClick(Sender: TObject);
    procedure LoadFromDBButtonClick(Sender: TObject);
    procedure StringGrid1OnDblClick(Sender: TObject);
    procedure ListBox1Exit(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
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

    zlecenia.Czysc;
    stanowiska.Czysc;

    Harmonogramator.Harmonogramuj(zlecenia, stanowiska, drh);
    print('Harmonogram dla reguly: ' + drh.NazwaReguly);
  end;

  NaniesEtapyZeStanowiskNaWykres;
  self.TabControl1Change(TabControl1);
end;

procedure TForm1.SaveToDBButtonClick(Sender: TObject);
var
  zlecenie : TZlecenie;
  etap : TZlecenieEtap;
begin
  for zlecenie in zlecenia do
    for etap in zlecenie do
      DBH.ZapiszEtap(etap);
end;

procedure TForm1.StringGrid1OnDblClick(Sender: TObject);
var
  etapZlecenia : TZlecenieEtap;
  stanowiskaPasujace : TStanowiska;
  stanowisko : TStanowisko;
  rect : TRect;
begin
  if (StringGrid1.Cols[StringGrid1.Col].Strings[0] = 'id_stanowiska_przydzielenie')
    and not (StringGrid1.Row = 0) then
  begin
    ListBox1.Items.Clear;
    etapZlecenia := ZaznaczonyEtapWTabeli;
    stanowiskaPasujace := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia);
    for stanowisko in stanowiskaPasujace do
    begin
      ListBox1.Items.Add(stanowisko.NAZ_STANOWISKA);
    end;
    rect := StringGrid1.CellRect(StringGrid1.Col, StringGrid1.Row);
    ListBox1.Left := rect.Left + StringGrid1.Left;
    ListBox1.Top := rect.Bottom + StringGrid1.Top;
    ListBox1.Width := rect.Right - rect.Left;
    if (StringGrid1.Top + StringGrid1.Height < ListBox1.Top + ListBox1.Height) then
      ListBox1.Top := (StringGrid1.Top + StringGrid1.Height) - ListBox1.Height;

    ListBox1.Visible := True;
    ListBox1.SetFocus;
  end;
end;

function TForm1.ZaznaczonyEtapWTabeli : TZlecenieEtap;
var
  zlecenie : TZlecenie;
begin
  Result := nil;
  zlecenie := zlecenia.Items[TabControl1.TabIndex];
  if StringGrid1.Row - 1 < zlecenie.Count then
    Result := zlecenie.Items[StringGrid1.Row - 1];
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
    print('Rozpoczecie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(kliknietyEtapZlecenia.DATA_ZAKONCZENIA));
    print('==== PIERWSZY ETAP =====');
    pierwszyEtap := kliknietyEtapZlecenia.PierwszyEtap;
    print('NR_ETAPU ' + IntToStr(pierwszyEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(pierwszyEtap.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(pierwszyEtap.DATA_ZAKONCZENIA));
    print('===== OSTATNI ETAP =====');
    ostatniEtap := kliknietyEtapZlecenia.OstatniEtap;
    print('NR_ETAPU ' + IntToStr(ostatniEtap.NR_ETAPU));
    print('Rozpoczecie ' + DateTimeToStr(ostatniEtap.DATA_ROZPOCZECIA));
    print('Zakonczenie ' + DateTimeToStr(ostatniEtap.DATA_ZAKONCZENIA));
  end;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
var
  zlecenie : TZlecenie;
  sl : TStringList;
  etap : TZlecenieEtap;
  i : Integer;
begin
  zlecenie := zlecenia.Items[TabControl1.TabIndex];
  Panel1.Color := KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
  StringGrid1.RowCount := 1;
  sl := TStringList.Create;
  for etap in zlecenie do
  begin
    sl.Clear;

    sl.Add(IntToStr(etap.NR_ETAPU));
    sl.Add(IntToStr(etap.ID_RODZAJE_STANOWISK));
    if not (etap.ID_STANOWISKA = 0) then
      sl.Add(IntToStr(etap.ID_STANOWISKA))
    else
      sl.Add(' ');
    if not (etap.DATA_ROZPOCZECIA = 0) then
      sl.Add(DateTimeToStr(etap.DATA_ROZPOCZECIA))
    else
      sl.Add(' ');
    if not (etap.DATA_ZAKONCZENIA = 0) then
      sl.Add(DateTimeToStr(etap.DATA_ZAKONCZENIA))
    else
      sl.Add(' ');
    if not (etap.ID_STANOWISKA_PRZYDZIELENIE = 0) then
      sl.Add(stanowiska.StanowiskoZId(etap.ID_STANOWISKA_PRZYDZIELENIE).NAZ_STANOWISKA)
    else
      sl.Add(' ');

    i := StringGrid1.RowCount;
    StringGrid1.RowCount := i + 1;
    StringGrid1.Rows[i].Clear;
    StringGrid1.Rows[i].AddStrings(sl);
  end;
  sl.Free;
  for i := 0 to StringGrid1.ColCount - 1 do
    AutoSizeCol(StringGrid1, i);
end;

procedure TForm1.print(printString : String);
begin
  Memo1.Text := Memo1.Text + printString + #13#10;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  etapZlecenia : TZlecenieEtap;
  poprzednieStanowisko : TStanowisko;
  nastepneStanowisko : TStanowisko;
begin
  etapZlecenia := ZaznaczonyEtapWTabeli;
  poprzednieStanowisko := stanowiska.StanowiskoZId(etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE);
  nastepneStanowisko := stanowiska
    .StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia)
    .Items[ListBox1.ItemIndex];
  if not (poprzednieStanowisko = nastepneStanowisko) then
  begin
    poprzednieStanowisko.UsunEtap(etapZlecenia);
    nastepneStanowisko.DodajEtap(etapZlecenia);
    etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE := nastepneStanowisko.ID_STANOWISKA;
    NaniesEtapyZeStanowiskNaWykres;
    TabControl1Change(TabControl1);
  end;
  ListBox1.Visible := false;
end;

procedure TForm1.ListBox1Exit(Sender: TObject);
begin
  ListBox1.Visible := False;
end;

procedure TForm1.LoadFromDBButtonClick(Sender: TObject);
begin
  zlecenia.Free;
  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  stanowiska.Czysc;

  PrzydzielEtapyDoStanowisk;
  NaniesEtapyZeStanowiskNaWykres;
  self.TabControl1Change(TabControl1);
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
  zlecenie: TZlecenie;
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

  StringGrid1.Cols[0].Add('nr_etapu');
  StringGrid1.Cols[1].Add('id_rodzaje_stanowisk');
  StringGrid1.Cols[2].Add('id_stanowiska');
  StringGrid1.Cols[3].Add('data_rozpoczecia');
  StringGrid1.Cols[4].Add('data_zakonczenia');
  StringGrid1.Cols[5].Add('id_stanowiska_przydzielenie');

  zlecenia := DBH.WyciagnijZleceniaDoHarmonogramowania;
  stanowiska := DBH.WyciagnijStanowiskaDoHarmonogramowania;

  ZbudujKoloryITaby;

  PrzydzielEtapyDoStanowisk;
  NaniesEtapyZeStanowiskNaWykres;
  self.TabControl1Change(TabControl1);
  // TODO: add machine
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

procedure TForm1.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 10;
end;

procedure TForm1.PrzydzielEtapyDoStanowisk;
var
  etap : TZlecenieEtap;
  zlecenie : TZlecenie;
begin
  for zlecenie in zlecenia do
    for etap in zlecenie do
      if (
        ( not (etap.ID_STANOWISKA_PRZYDZIELENIE = 0)) and
        ( not (etap.DATA_ROZPOCZECIA = 0)) and
        ( not (etap.DATA_ZAKONCZENIA = 0))
      ) then
        stanowiska.StanowiskoZId(etap.ID_STANOWISKA_PRZYDZIELENIE).DodajEtap(etap);
end;

procedure TForm1.NaniesEtapyZeStanowiskNaWykres;
var
  stanowisko : TStanowisko;
  etapZlecenia : TZlecenieEtap;
begin
  Series1.Clear;
  for stanowisko in stanowiska do
  begin
    for etapZlecenia in stanowisko.listaEtapow do
    begin
      if (
        not (etapZlecenia.DATA_ROZPOCZECIA = 0) and
        not (etapZlecenia.DATA_ZAKONCZENIA = 0) and
        not (etapZlecenia.ID_STANOWISKA_PRZYDZIELENIE = 0)) then
        begin
          etapZlecenia.ganttID := Series1.AddGanttColor(etapZlecenia.DATA_ROZPOCZECIA,
                                                    etapZlecenia.DATA_ZAKONCZENIA,
                                                    stanowiska.IndexOf(stanowisko),
                                                    stanowisko.NAZ_STANOWISKA,
                                                    KH.KolorDlaId(etapZlecenia.daneZlecenia.ID_ZLECENIA));
        end;
    end;
  end;
  zlecenia.PolaczKolejneEtapyZlecenWSerii(Series1);
end;

procedure TForm1.ZbudujKoloryITaby;
var
  zlecenie : TZlecenie;
begin
  TabControl1.Tabs.Clear;
  for zlecenie in zlecenia do
  begin
    KH.KolorDlaId(zlecenie.daneZlecenia.ID_ZLECENIA);
    TabControl1.Tabs.Add(IntToStr(zlecenie.daneZlecenia.ID_ZLECENIA));
  end;
end;

end.
