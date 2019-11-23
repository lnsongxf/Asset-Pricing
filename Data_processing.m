%%  Data processing 
%   - If the data is not in the folder, the files are downloaded.
%   - Imports the data from the files into tables 

% Monthly portfolios for US stocks sorted by size and momentum
monthly_url = "https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/25_Portfolios_ME_Prior_12_2_CSV.zip";
monthly_filename = download_data(monthly_url);

% Liquqidity factor 
liquidity_url = "http://faculty.chicagobooth.edu/lubos.pastor/research/liq_data_1962_2013.txt";
liquidity_filename = download_data(liquidity_url);

% Risk free rate and excess market return
fama_french_url = "https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Research_Data_Factors_CSV.zip";
fama_french_filename = download_data(fama_french_url);

% Checks whether the data has been imported into tables
if(~exist('monthly_data','var') || ~exist('liquidity_data','var'))
    fprintf("Importing the data into datatables.\n\n")
    % Importing monthly data into datatable
    opts = detectImportOptions(monthly_filename{1});       % Automatically detects import settings
    monthly_data = readtable(monthly_filename{1}, opts);

    % Importing liquidity data into datatable
    opts = detectImportOptions(liquidity_filename);        % Automatically detects import settings
    liquidity_data = readtable(liquidity_filename, opts);
    
    % Importing liquidity data into datatable
    opts = detectImportOptions(fama_french_filename);        % Automatically detects import settings
    market_data = readtable(fama_french_filename, opts);
    risk_free_data = market_data(:,2);
    excess_return_data = market_data(:,5);
    
    % Manually fixing the variable names
    monthly_data.Properties.VariableNames(1) = "Months";
    liquidity_data.Properties.VariableNames(1) = "Months";
    liquidity_data.Properties.VariableNames(2) = "Levels_of_aggregate_liquidity";
    liquidity_data.Properties.VariableNames(3) = "Innovations_in_aggregate_liquidity";
    liquidity_data.Properties.VariableNames(4) = "Traded_liquidity_factor";
    
    % Manually filtering the data into 6 monthly tables
    % Gather data from the first date available to August 2008
    startIndex = find(monthly_data.Months == monthly_data.Months(1));
    endIndex = find(monthly_data.Months == 200808);

    %   Average Value Weighted Returns -- Monthly
    AVWR = monthly_data(startIndex(1):endIndex(1),:);
    %   Average Equal Weighted Returns -- Monthly
    AEWR = monthly_data(startIndex(2):endIndex(2),:);
    %   Number of Firms in Portfolios
    NFP = monthly_data(startIndex(3):endIndex(3),:);
    %   Average Firm Size
    AVS = monthly_data(startIndex(4):endIndex(4),:);
    %   Equally-Weighted Average of Prior Returns
    EQAPR = monthly_data(startIndex(5):endIndex(5),:);
    %   Value-Weighted Average of Prior Returns
    VWAPR = monthly_data(startIndex(6):endIndex(6),:);
else
    fprintf("The data has already been imported into datatables.\n\n")
end 

function filename = download_data(file_url)
    % This function takes in the URL, finds the filename and downloads it to the directory. 
    filename = extractBetween(file_url, max(strfind(file_url,'/'))+1, length(file_url{1}));
    if(~isfile(filename))
        % If the file is not in the folder then it is downloaded
        fprintf("Downloading %s.\n\n",filename)
        websave(filename, file_url);
        if(contains(filename,".zip"))
           % If the file is a .zip file then unzip
           fprintf("Unzipping %s.\n\n",filename)
           filename = unzip(filename);
        end
    else
        % If the file already exists
        fprintf("%s already exists in folder.\n\n",filename)
        if(contains(filename, ".zip"))
            % Removes .zip from the end of the filename if the file has already been imported
            filename = extractBetween(filename, 1, length(filename{1})-4);
        end
        if(contains(filename, "_CSV"))
            % Changes _CSV to .CSV so that the data import works in either case
            filename = extractBetween(filename, 1, length(filename{1})-4) + ".CSV";
        end
    end
end


