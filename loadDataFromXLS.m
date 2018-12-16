clc
sheet = 1;

handles.notowania = xlsread(['./dane/' handles.filename], sheet, 'A:A');    %wczytaj dane z pliku, aby okreœliæ rozmiar
dataLength = length(handles.notowania);                                     %okreœl rozmiar wczytanych danych
initialImportPosition = dataLength-handles.daysImported+1;                  %okreœl pozycjê pierwszej danej do wczytania

if (initialImportPosition<1)                                                %walidacja danych z interfejsu
    initialImportPosition=1;
end

datesRange = ['A' num2str(initialImportPosition) ':A' num2str(dataLength)];            %z kolumny A pobieram daty
pricesRange = ['B' num2str(initialImportPosition) ':B' num2str(dataLength)];           %z kolumny B pobieram wartoœci (ceny zamkniêcia lub wartoœci wskaŸników makroekonomicznych)

if handles.ImportOnlyLast == 0
    handles.notowania = xlsread(['./dane/' handles.filename], sheet, 'B:B');
    handles.datynotowan = datenum(xlsread(['./dane/' handles.filename], sheet, 'A:A'))+datenum('30-Dec-1899');      %konwersja miêdzy excelowym i matlabowym zapisem dat
else
    handles.notowania = xlsread(['./dane/' handles.filename], sheet, pricesRange);
    handles.datynotowan = datenum(xlsread(['./dane/' handles.filename], sheet, datesRange))+datenum('30-Dec-1899'); %konwersja miêdzy excelowym i matlabowym zapisem dat
end