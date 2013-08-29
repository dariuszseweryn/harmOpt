program Project1;



uses
  Vcl.Forms,
  DataBaseHelper in 'DataBaseHelper.pas',
  ZlecenieEtap in 'ZlecenieEtap.pas',
  Harmonogramator in 'Harmonogramator.pas',
  MainWindow in 'MainWindow.pas' {Form1},
  QueryHelper in 'QueryHelper.pas',
  Stanowiska in 'Stanowiska.pas',
  Stanowisko in 'Stanowisko.pas',
  Zlecenia in 'Zlecenia.pas',
  Zlecenie in 'Zlecenie.pas',
  ZlecenieDane in 'ZlecenieDane.pas',
  CzasHelper in 'CzasHelper.pas',
  KolorHelper in 'KolorHelper.pas',
  Etapy in 'Etapy.pas',
  DyspozytorskaRegulaHarmonogramowania in 'DyspozytorskaRegulaHarmonogramowania.pas',
  DyspozytorskaRegulaHarmonogramowaniaSPT in 'DyspozytorskaRegulaHarmonogramowaniaSPT.pas',
  DyspozytorskaRegulaHarmonogramowaniaEDD in 'DyspozytorskaRegulaHarmonogramowaniaEDD.pas',
  DyspozytorskaRegulaHarmonogramowaniaMDD in 'DyspozytorskaRegulaHarmonogramowaniaMDD.pas',
  DyspozytorskaRegulaHarmonogramowaniaMST in 'DyspozytorskaRegulaHarmonogramowaniaMST.pas',
  DyspozytorskaRegulaHarmonogramowaniaSCR in 'DyspozytorskaRegulaHarmonogramowaniaSCR.pas',
  DyspozytorskaRegulaHarmonogramowaniaAOPN in 'DyspozytorskaRegulaHarmonogramowaniaAOPN.pas',
  DyspozytorskaRegulaHarmonogramowaniaSOPN in 'DyspozytorskaRegulaHarmonogramowaniaSOPN.pas',
  DyspozytorskaRegulaHarmonogramowania1ST in 'DyspozytorskaRegulaHarmonogramowania1ST.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
