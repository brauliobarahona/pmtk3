function publishDemos(wikiFile)
% Publish all of the PMTK3 demos and create the wiki TOC page.
% See publishFolder, pmlCodeRefs, pmlChapterPages for settings that might
% affect this function. 
% PMTKneedsMatlab 
%%
wikiOnly = true;     % set true if you only want to regenerate the wiki and 
                     % index.html pages, and not republish. 
svnAutomatically = false;

if nargin == 0,  
    wikiFile = fullfile(getConfigValue('PMTKlocalWikiPath'), 'Demos.wiki'); 
end
googleRoot = 'http://pmtk3.googlecode.com/svn/trunk/docs/demoOutput';
cd(fullfile(pmtk3Root(), 'demos'));
%% book demos
d = cellfuncell(@(c)fullfile('bookDemos', c), dirs(fullfile(pmtk3Root(), 'demos', 'bookDemos')));
dirEmpty = @(d)isempty(mfiles(d, 'topOnly', true));
for i = 1:numel(d)
    if ~dirEmpty(d{i})
        publishFolder(d{i}, wikiOnly);
    end
end
wikiTextBook = cell(numel(d), 1);
for i=1:numel(d)
    if ~dirEmpty(d{i})
        wikiTextBook{i} = sprintf(' * [%s/%s/index.html %s]',googleRoot, strrep(d{i}, '\', '/'), fnameOnly(d{i}));
    end
end
wikiTextBook = filterCell(wikiTextBook, @(c)~isempty(c));
wikiTextBook = [{'#summary A list of every PMTK3 demo'
             'auto-generated by publishDemos'
             ''
             '== Book Demos =='
             ''
             ''
             ''
             ''
            }
            wikiTextBook
            ];
%% other demos
linkToPml = false; 
d = cellfuncell(@(c)fullfile('otherDemos', c), dirs(fullfile(pmtk3Root(), 'demos', 'otherDemos')));
dirEmpty = @(d)isempty(mfiles(d, 'topOnly', true));
for i = 1:numel(d)
    if ~dirEmpty(d{i})
        publishFolder(d{i}, wikiOnly, linkToPml);
    end
end
wikiTextOther   = cell(numel(d), 1);
for i=1:numel(d)
    if ~dirEmpty(d{i})
        wikiTextOther{i} = sprintf(' * [%s/%s/index.html %s]',googleRoot, strrep(d{i}, '\', '/'), fnameOnly(d{i}));
    end
end
wikiTextOther = filterCell(wikiTextOther, @(c)~isempty(c));
wikiTextOther = [{
             '== Other Demos == '
             '_a collection of demos not appearing in the book_'
             ''
             ''
             ''
             ''
            }
            wikiTextOther
            ];

wikiText = [wikiTextBook; wikiTextOther]; 
writeText(wikiText, wikiFile);
%%
if svnAutomatically
    system(sprintf('svn ci %s -m "auto-updated by publishDemos"', wikiFile));
    docdir = fullfile(pmtk3Root(), 'docs', 'demoOutput');
    system(sprintf('svn ci %s -m "auto-updated by publishDemos"', docdir));
end
end

