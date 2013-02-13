function varargout = map_visual_receptive_field(varargin)
% MAP_VISUAL_RECEPTIVE_FIELD M-file for map_visual_receptive_field.fig
%      MAP_VISUAL_RECEPTIVE_FIELD, by itself, creates a new MAP_VISUAL_RECEPTIVE_FIELD or raises the existing
%      singleton*.
%
%      H = MAP_VISUAL_RECEPTIVE_FIELD returns the handle to a new MAP_VISUAL_RECEPTIVE_FIELD or the handle to
%      the existing singleton*.
%
%      MAP_VISUAL_RECEPTIVE_FIELD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAP_VISUAL_RECEPTIVE_FIELD.M with the given input arguments.
%
%      MAP_VISUAL_RECEPTIVE_FIELD('Property','Value',...) creates a new MAP_VISUAL_RECEPTIVE_FIELD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before map_visual_receptive_field_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to map_visual_receptive_field_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help map_visual_receptive_field

% Last Modified by GUIDE v2.5 05-Feb-2013 03:09:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @map_visual_receptive_field_OpeningFcn, ...
                   'gui_OutputFcn',  @map_visual_receptive_field_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before map_visual_receptive_field is made visible.
function map_visual_receptive_field_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to map_visual_receptive_field (see VARARGIN)

% Choose default command line output for map_visual_receptive_field
handles.output = hObject;

% keyboard;
assignin('base', 'Trials', varargin{1});

session.trials = varargin{1};
clear('varargin');

session.bin_width = 1;
session.baseline_period = [-200 0];
session.response_period = [60 180];
session.raster_plotting_period = [-200 500];
% session.alpha = 0.95;

session.raster_plotting_period_centers = get_bin_centers(session.raster_plotting_period, session.bin_width);

% Formatting
session = get_unit_nums(session);
session = format_trials(session);

% Analysis
session = analyze_session(session);

% Put the session struct into handles
handles.session = session;

% Update unit number
handles = update_unit_num(handles);

% Get RF loc info
% handles = update_rf_loc(handles);

% keyboard;
% assignin('base', 'session', handles.session);

% Set closing function
set(handles.figure1, 'CloseRequestFcn', @map_visual_receptive_field_CloseRequestFcn);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes map_visual_receptive_field wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = map_visual_receptive_field_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in UnitNumPopupmenu.
function UnitNumPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to UnitNumPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns UnitNumPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UnitNumPopupmenu

handles = update_unit_num(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function UnitNumPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnitNumPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RFLocSelectPopupmenu.
function RFLocSelectPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to RFLocSelectPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RFLocSelectPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RFLocSelectPopupmenu

handles = update_rf_loc(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RFLocSelectPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RFLocSelectPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClosePushbutton.
function ClosePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ClosePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keyboard;
close(handles.figure1);


% --- Executes on attempt to close xex.
function map_visual_receptive_field_CloseRequestFcn(hObject, eventdata)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB

% disp('close function executing');
delete(hObject);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function session = get_unit_nums(session)

unit_nums = [session.trials(1).Units.Code];
num_units = length(unit_nums);
session.num_units = num_units;

for ii = 1 : num_units
	session.unit_data(ii).unit_num = unit_nums(ii);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function session = format_trials(session)
	
RFONCD = 1007;
RFOFFCD = 1010;
RWCD = 1012;
PATNUMCD = 3000;
PATRCD = 5000;
PATGCD = 5300;
PATBCD = 5600;
PATXCD = 6000;
PATYCD = 6500;
PATONCD = 7000;

% First dump trial #1
session.trials = session.trials(2:end);

for ii = 1:length(session.trials)
	event_packet = [double([session.trials(ii).Events.Code]); double([session.trials(ii).Events.Time])]';
	if ~isempty (session.trials(ii).Events(find(event_packet(:, 1) == RFONCD)))
		rf_on_time = double(event_packet(find(event_packet(:, 1) == RFONCD), 2));

		if rf_on_time < 8000
			
			session.trials(ii).rf_on_time = rf_on_time;
			session.trials(ii).rf_off_time = double(event_packet(find(event_packet(:,1) == RFOFFCD), 2));
			if isempty(session.trials(ii).rf_off_time)
				session.trials(ii).rf_off_time = double(event_packet(find(event_packet(:,1) == RWCD), 2));
			end
			session.trials(ii).Rftime = session.trials(ii).rf_off_time - session.trials(ii).rf_on_time;

			% Now find RF object information for each trial
			first_patcd = min(find((event_packet(:,2) == rf_on_time) & (event_packet(:,1) > PATNUMCD))); % The 3000 code gives the # of objects following
			last_patcd = max(find((event_packet(:,2) == rf_on_time) & (event_packet(:,1) > 5000))); % this is to double check
			num_codes = last_patcd - first_patcd;
			num_objs = double(event_packet(first_patcd,1)) - PATNUMCD;
			% disp(num2str(num_objs));
			
			expected_codes_per_obj = 6;
			if (num_objs * expected_codes_per_obj ~= num_codes)
				errordlg('The number of object codes does not match the expected value based on the number of objects','Warning');
			end
			
			% This loop could probably be removed, since presumably there's only one
			% RF stimulus in each trial, but there's minimal overhead, and if it ain't broke...
			counter = first_patcd + 1; % because first code is 3000 (number of objects)
			for jj = 1:num_objs
				session.trials(ii).obj(jj).pattern = event_packet(counter,1) - PATONCD;
				counter = counter + 1;
				session.trials(ii).obj(jj).xpos = (event_packet(counter,1) - PATXCD)/10;
				counter = counter + 1;
				session.trials(ii).obj(jj).ypos = (event_packet(counter,1) - PATYCD)/10;
				counter = counter + 1;
				session.trials(ii).obj(jj).red = event_packet(counter,1) - PATRCD;
				counter = counter + 1;
				session.trials(ii).obj(jj).green = event_packet(counter,1) - PATGCD;
				counter = counter + 1;
				session.trials(ii).obj(jj).blue = event_packet(counter,1) - PATBCD;
				counter = counter + 1;
			end
			
		end
	end
	
	% RF location
	try
		session.trials(ii).rf_x = session.trials(ii).obj(1).xpos;
		session.trials(ii).rf_y = session.trials(ii).obj(1).ypos;
		if isempty(session.trials(ii).rf_x) || isempty(session.trials(ii).rf_y)
			session.trials(ii).rf_x = NaN;
			session.trials(ii).rf_y = NaN;
		end
	catch
		session.trials(ii).rf_x = NaN;
		session.trials(ii).rf_y = NaN;
	end
	
	% Format unit data
	for jj = 1 : session.num_units
		try
			session.trials(ii).Units(jj).rf_aligned_times = session.trials(ii).Units(jj).Times - session.trials(ii).rf_on_time;
			session.trials(ii).Units(jj).baseline_counts = get_binned_counts(session.trials(ii).Units(jj).rf_aligned_times, session.baseline_period, session.bin_width);
			session.trials(ii).Units(jj).response_counts = get_binned_counts(session.trials(ii).Units(jj).rf_aligned_times, session.response_period, session.bin_width);
			session.trials(ii).Units(jj).raster_plotting_period_counts = get_binned_counts(session.trials(ii).Units(jj).rf_aligned_times, session.raster_plotting_period, session.bin_width);
			% keyboard;
			session.trials(ii).Units(jj).all_counts_spike_density = 1000 * sdf(10, 1000, session.trials(ii).Units(jj).raster_plotting_period_counts);
			session.trials(ii).Units(jj).baseline_spike_density = 1000 * sdf(10, 1000, session.trials(ii).Units(jj).baseline_counts);
			session.trials(ii).Units(jj).response_spike_density = 1000 * sdf(10, 1000, session.trials(ii).Units(jj).response_counts);
		catch
			session.trials(ii).Units(jj).rf_aligned_times = NaN;
			session.trials(ii).Units(jj).baseline_counts = NaN;
			session.trials(ii).Units(jj).response_counts = NaN;
			session.trials(ii).Units(jj).raster_plotting_period_counts = NaN;
			session.trials(ii).Units(jj).all_counts_spike_density = NaN;
			session.trials(ii).Units(jj).baseline_spike_density = NaN;
			session.trials(ii).Units(jj).response_spike_density = NaN;
		end
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function session = analyze_session(session)

% Make the group index
grouping_cols = [session.trials.rf_x;session.trials.rf_y]';
isnanmask = any(isnan(grouping_cols), 2);
rfloc_groups = unique(grouping_cols(~isnanmask,:), 'rows');
% Sort the RF locations
rfloc_groups = sort_columns(rfloc_groups, [1,2], {'ascend', 'descend'});
num_rfloc_groups = size(rfloc_groups, 1);
rfloc_group_idx = nan(length(session.trials),1);
for ii = 1 : num_rfloc_groups
	rfloc_group_idx(ismember(grouping_cols, rfloc_groups(ii, :), 'rows')) = ii;
end
rfloc_group_idx_cell = num2cell(rfloc_group_idx);
[session.trials.rf_location_group] = deal(rfloc_group_idx_cell{:});

% Now aggregate the unit data
unit_data = [session.trials.Units];
num_trials = length(session.trials);
base_unit_idx = session.num_units .* [1:num_trials] - session.num_units;
for ii = 1 : session.num_units
	unit_idx = base_unit_idx + ii;
	this_unit_data = unit_data(unit_idx);
	for jj = 1 : num_rfloc_groups
		this_rf_loc = struct();
		this_rf_loc.rf_x = rfloc_groups(jj, 1);
		this_rf_loc.rf_y = rfloc_groups(jj, 2);
		this_rf_loc.per_trial = this_unit_data(rfloc_group_idx == jj);
		% Make the arrays of spike counts
		cumulative_rf_aligned = [this_rf_loc.per_trial.rf_aligned_times];
		% Add an array that associates each spike with the correct trial
		spikes_per_trial = cellfun('length', {this_rf_loc.per_trial.rf_aligned_times});
		trial_id = [];
		for kk = 1 : length(spikes_per_trial)
			trial_id = [trial_id repmat(kk, 1, spikes_per_trial(kk))];
		end
		in_raster_plotting_period = cumulative_rf_aligned >= min(session.raster_plotting_period) & cumulative_rf_aligned <= max(session.raster_plotting_period);
		this_rf_loc.cumulative_rf_aligned = cumulative_rf_aligned(in_raster_plotting_period);
		this_rf_loc.trial_id = trial_id(in_raster_plotting_period);
		
		% Make the spike density functions
		% all counts
		all_counts_sdfmat = vertcat(this_rf_loc.per_trial.all_counts_spike_density);
		all_counts_mean_spike_density = mean(all_counts_sdfmat, 1);
		all_counts_sem_spike_density = std(all_counts_sdfmat,1) / sqrt(size(all_counts_sdfmat,1));
		this_rf_loc.all_counts_mean_spike_density = all_counts_mean_spike_density;
		this_rf_loc.all_counts_sem_spike_density = all_counts_sem_spike_density;
		
		% Comparison of response to baseline
		% baseline period
		baseline_sdfmat = vertcat(this_rf_loc.per_trial.baseline_spike_density);
		baseline_mean_spike_density = mean(baseline_sdfmat, 1);
		baseline_sem_spike_density = std(baseline_sdfmat,1) / sqrt(size(baseline_sdfmat,1));
		this_rf_loc.baseline_mean_spike_density = baseline_mean_spike_density;
		this_rf_loc.baseline_sem_spike_density = baseline_sem_spike_density;
		% response period
		response_sdfmat = vertcat(this_rf_loc.per_trial.response_spike_density);
		response_mean_spike_density = mean(response_sdfmat, 1);
		response_sem_spike_density = std(response_sdfmat,1) / sqrt(size(response_sdfmat,1));
		this_rf_loc.response_mean_spike_density = response_mean_spike_density;
		this_rf_loc.response_sem_spike_density = response_sem_spike_density;
		% Metric of difference between response and baseline activity
		this_rf_loc.response_v_baseline_spike_density = mean(response_mean_spike_density) - mean(baseline_mean_spike_density);
		
		% Significance of difference between response and baseline activity
		% baseline
		baseline_counts = get_binned_counts(this_rf_loc.cumulative_rf_aligned, session.baseline_period, session.bin_width);
		baseline_count_distribution = get_count_distribution(baseline_counts);
		% response
		response_counts = get_binned_counts(this_rf_loc.cumulative_rf_aligned, session.response_period, session.bin_width);
		response_count_distribution = get_count_distribution(response_counts);
		% adjust the number of bins
		max_baseline_counts = max(baseline_counts);
		max_response_counts = max(response_counts);
		bins = 0 : max(max_baseline_counts, max_response_counts);
		baseline_count_distribution(length(baseline_count_distribution)+1 : length(bins)) = 0;
		response_count_distribution(length(response_count_distribution)+1 : length(bins)) = 0;
		this_rf_loc.baseline_count_distribution = baseline_count_distribution;
		this_rf_loc.response_count_distribution = response_count_distribution;
		% calculate significance
		if max(bins) > 0
			% Figure out if there's a signficant difference from baseline
			% Test against the Poisson distribution by specifying observed and
			% expected counts (see Example 4 from http://www.mathworks.com/help/stats/chi2gof.html)
			% bins = 0:5; obsCounts = [6 16 10 12 4 2]; n = sum(obsCounts);
			% lambdaHat = sum(bins.*obsCounts) / n;
			% expCounts = n * poisspdf(bins,lambdaHat);
			% [h,p,st] = chi2gof(bins,'ctrs',bins,'frequency',obsCounts, ...
			%                    'expected',expCounts,'nparams',1)
			% 
			% bins = 0 : (length(baseline_count_distribution) - 1);
			% n = sum(baseline_count_distribution);
			% lambdaHat = sum(bins.*baseline_count_distribution) / n;
			% expCounts = n * poisspdf(bins, lambdaHat);
			% [h,p,st] = chi2gof(bins, 'nbins', length(bins), 'frequency', baseline_count_distribution, 'expected', expCounts, 'nparams', 1);
			[is_sig, pval, sig_test_stats] = chi2gof(bins, 'ctrs', bins, 'frequency', response_count_distribution, 'expected', baseline_count_distribution);
		else
			[is_sig, pval, sig_test_stats] = deal(false, NaN, struct());
		end
		this_rf_loc.is_sig = is_sig;
		this_rf_loc.pval = pval;
		this_rf_loc.sig_test_stats = sig_test_stats;
		
		session.unit_data(ii).rf_loc(jj) = this_rf_loc;
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sorted_columns = sort_columns(columns, column_sort_order, sort_mode)

sort_dim = 1;
% sort_mode = 'ascend';
% sort_mode = 'descend';

if isempty(column_sort_order)
	sorted_columns = columns;
else
	[sorted_column_vals, sort_idx] = sort(columns(:, column_sort_order(1)), sort_dim, sort_mode{1});
	sorted_columns = columns(sort_idx, :);
	unique_column_vals = unique(sorted_column_vals);
	for ii = 1 : length(unique_column_vals)
		this_val_idx = find(sorted_column_vals == unique_column_vals(ii));
		sorted_columns(this_val_idx, :) = sort_columns(sorted_columns(this_val_idx, :), column_sort_order(2:end), sort_mode(2:end));
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function binned_counts = get_binned_counts(spike_times, bin_range, bin_width)

spike_bin_edges = get_bin_edges(bin_range, bin_width);
binned_counts = histc(spike_times, spike_bin_edges);
binned_counts = binned_counts(1:end-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bin_edges = get_bin_edges(bin_range, bin_width)

bin_half_width = bin_width / 2;
bin_edges = [(min(bin_range) - bin_half_width) : bin_width : (max(bin_range) + bin_half_width)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bin_centers = get_bin_centers(bin_range, bin_width)

bin_edges = get_bin_edges(bin_range, bin_width);
bin_half_width = bin_width / 2;
bin_centers = bin_edges(1:end-1) + bin_half_width;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function count_distribution = get_count_distribution(binned_counts)

count_distribution = zeros(1, max(binned_counts)+1);
for ii = 0 : max(binned_counts)
	count_distribution(ii+1) = sum(binned_counts==ii);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Used to updated the UnitNumPopupmenu widget
function handles = update_unit_num(handles)

unit_data = handles.session.unit_data;
unit_num_string_cell = {};
for ii = 1 : length(unit_data)
	unit_num_string_cell{ii} = num2str(unit_data(ii).unit_num);
end
set(handles.UnitNumPopupmenu, 'String', unit_num_string_cell);
handles.unit_num_ind = get(handles.UnitNumPopupmenu, 'Value');

% handles = make_heatmap(handles);
handles = update_rf_loc(handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Used to updated the RFLocSelectPopupmenu widget
function handles = update_rf_loc(handles)

unit_num = handles.unit_num_ind;

rf_loc_info = handles.session.unit_data(unit_num).rf_loc;
rf_loc_string_cell = {};
valid_rf_locs = [];
for ii = 1 : length(rf_loc_info)
	rf_loc_string_cell{ii} = ['X: ', num2str(rf_loc_info(ii).rf_x), ', Y: ', num2str(rf_loc_info(ii).rf_y)];
	if ~isempty(rf_loc_info(ii).cumulative_rf_aligned)
		valid_rf_locs = [valid_rf_locs ii];
	end
end
set(handles.RFLocSelectPopupmenu, 'String', rf_loc_string_cell(valid_rf_locs));
handles.rf_loc_ind = valid_rf_locs(get(handles.RFLocSelectPopupmenu, 'Value'));
handles.valid_rf_locs = valid_rf_locs;

handles = make_heatmap(handles);
handles = make_rasterplot(handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = make_heatmap(handles)


sig_LineWidth = 1.5;
sig_LineColor = 'k';
nonsig_LineWidth = .5;
nonsig_LineColor = [.75, .75, .75];
selected_location_Marker = 'd';
nonselected_location_Marker = 'o';

% unit_num = 1;
unit_num = handles.unit_num_ind;
axes(handles.HeatMapAxes);

rf_x = [handles.session.unit_data(unit_num).rf_loc.rf_x]';
rf_y = [handles.session.unit_data(unit_num).rf_loc.rf_y]';
raw_vals = [handles.session.unit_data(unit_num).rf_loc.response_v_baseline_spike_density]';
scaled_vals = raw_vals ./ (max(abs(raw_vals)));
is_sig = logical([handles.session.unit_data(unit_num).rf_loc.is_sig]');

% And here's the plotting bit
LegHands = [];
LegTags = {};
FaceColor = {};
for ii = 1 : length(scaled_vals)
	rfloc_h = plot(rf_x(ii), rf_y(ii));
	if ii == handles.rf_loc_ind
		Marker = 'd';
	else
		Marker = 'o';
	end
	if isnan(scaled_vals(ii)) || ~ismember(ii, handles.valid_rf_locs)
		LineColor = 'w';
		FaceColor{ii} = 'w';
		LineWidth = 1;
	else
		% Adjust border according to whether results are significant
		if is_sig(ii)
			LineColor = sig_LineColor;
			LineWidth = sig_LineWidth;
		else
			LineColor = nonsig_LineColor;
			LineWidth = nonsig_LineWidth;
		end
		% Adjust fill color according to scaled_vals
		if scaled_vals(ii) > 0
			% Larger abs value -> less green/blue (more red)
			FaceColor{ii} = [1, (1 - abs(scaled_vals(ii))), (1 - abs(scaled_vals(ii)))];
		else		
			% Larger abs value -> less red/green (more blue)
			FaceColor{ii} = [(1 - abs(scaled_vals(ii))), (1 - abs(scaled_vals(ii))), 1];
		end
	end
	LegTags{ii} = ['Channel_(' num2str(rf_x(ii)), ',', num2str(rf_y(ii)), ')'];
	set(rfloc_h, 'Color', LineColor, 'LineStyle', 'none',...
		'LineWidth', LineWidth, 'Marker', Marker, 'MarkerFaceColor', FaceColor{ii},...
		'MarkerSize', 15, 'Tag', LegTags{ii}...
		);
	hold on;
end
hold off;

axhand = gca;

% Set x and y lims
xlims = xlim(gca);
xlims_buffer = round(0.1 * (max(xlims) - min(xlims)));
xlims = [xlims(1) - xlims_buffer, xlims(2) + xlims_buffer];
xlim(gca, xlims);

ylims = ylim(gca);
ylims_buffer = round(0.1 * (max(ylims) - min(ylims)));
ylims = [ylims(1) - ylims_buffer, ylims(2) + ylims_buffer];
ylim(gca, ylims);

% Title
title('Response Period v Baseline Activity');
% X and Y axis labels
xlabel('RF X (deg)');
ylabel('RF Y (deg)');

% Legend
LegStr = {['+' num2str(max(raw_vals)) ' Hz'], [num2str(min(raw_vals)) ' Hz'], 'Significant', 'Non-significant', 'Selected location'};
LegMarkerProps = {...
	struct('Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', FaceColor{min(find(raw_vals==max(raw_vals)))}, 'MarkerSize', 10),...
	struct('Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', FaceColor{min(find(raw_vals==min(raw_vals)))}, 'MarkerSize', 10),...
	struct('Color', sig_LineColor, 'LineStyle', 'none', 'LineWidth', sig_LineWidth, 'Marker', 'o', 'MarkerFaceColor', 'w', 'MarkerSize', 10),...
	struct('Color', nonsig_LineColor, 'LineStyle', 'none', 'LineWidth', nonsig_LineWidth, 'Marker', 'o', 'MarkerFaceColor', 'w', 'MarkerSize', 10),...
	struct('Color', 'k', 'LineStyle', 'none', 'Marker', selected_location_Marker, 'MarkerFaceColor', 'w', 'MarkerSize', 10),...
	};
for ii = 1 : length(LegStr)
	LegHands = [LegHands; findobj(axhand, 'Tag', LegTags{ii})];
end
legend_h = legend(LegHands, LegStr{:}, 'Location', 'NorthEastOutside');
setlegendmarkerprops(legend_h, LegMarkerProps);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = make_rasterplot(handles)

unit_num = handles.unit_num_ind;
rf_loc_ind = handles.rf_loc_ind;

xlims = handles.session.raster_plotting_period;
ylims = [-50 250];

axes(handles.RasterAxes);

% Get raster data
spike_times = handles.session.unit_data(unit_num).rf_loc(rf_loc_ind).cumulative_rf_aligned;
spike_trialnums = handles.session.unit_data(unit_num).rf_loc(rf_loc_ind).trial_id;
num_trials = length(unique(spike_trialnums));
% This is a trick to make the trial numbers go from the lower part of the axes to the bottom
space = abs(min(ylims));
spacing = space / (num_trials+1);
spike_trialnums = (-1 * spacing * spike_trialnums);
spike_times = spike_times';
spike_trialnums = spike_trialnums';

% Get spike density data
spike_bin_centers = handles.session.raster_plotting_period_centers;
spike_bin_vals = handles.session.unit_data(unit_num).rf_loc(rf_loc_ind).all_counts_mean_spike_density;

% Plot the data
[axhand, spikedensity_h, spikeraster_h] = plotyy(spike_bin_centers, spike_bin_vals, spike_times, spike_trialnums);
spikedensity_axhand = axhand(1);
spikeraster_axhand = axhand(2);

% axes(spikedensity_h);
hold on;
% Draw RF on line
rf_on_line_x = [0, 0];
rf_on_line_y = ylims;
plot(rf_on_line_x, rf_on_line_y, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 0.5, 'Marker', 'none');
% Draw line for spike density == 0
spikedens0_x = xlims;
spikedens0_y = [0, 0];
plot(spikedens0_x, spikedens0_y, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'none');
% Draw patch for baseline period
baseline_period = handles.session.baseline_period;
baseline_patch_x = [baseline_period(1), baseline_period(1), baseline_period(2), baseline_period(2)];
baseline_patch_y = [ylims(1), ylims(2), ylims(2), ylims(1)];
baseline_patch_h = patch(baseline_patch_x, baseline_patch_y, 'y');
set(baseline_patch_h, 'FaceAlpha', 0.5, 'LineStyle', 'none');
% Draw patch for response period
response_period = handles.session.response_period;
response_patch_x = [response_period(1), response_period(1), response_period(2), response_period(2)];
response_patch_y = [ylims(1), ylims(2), ylims(2), ylims(1)];
response_patch_h = patch(response_patch_x, response_patch_y, 'g');
set(response_patch_h, 'FaceAlpha', 0.5, 'LineStyle', 'none');
% keyboard;
% Reset axes limits and turn hold off
xlim(spikedensity_axhand, xlims);
xlim(spikeraster_axhand, xlims);
ylim(spikedensity_axhand, ylims);
ylim(spikeraster_axhand, ylims);
hold off;

% Formatting
set(spikeraster_h, 'Color', 'k', 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 2);
set(spikedensity_h, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none');
xlabel(spikedensity_axhand, 'Time relative to RF on (ms)');
ylabel(spikedensity_axhand, 'Spike rate (Hz)');
set(spikedensity_axhand, 'YColor', 'k', 'YTick', [0 : 50 : max(ylims)]);
set(spikeraster_axhand, 'YTick', []);

% Legend
LegStr = {'Baseline period', 'Response period'};
LegHands = [baseline_patch_h, response_patch_h];
legend_h = legend(LegHands, LegStr{:}, 'Location', 'NorthEastOutside');