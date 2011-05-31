let g:mvpTitle = "title"
let g:mvpArticle= "no article"

function! LrcPerl()
perl << EOP
use threads;
use Win32::OLE;
use Time::HiRes qw /usleep/;

## open lrc
open LRC, "snow.lrc" or die "Cannot open lrc: $!";

## start player in a thread
sub thread_play
{
	my $shell = Win32::OLE->new("WScript.Shell") or die "Cannot create WScript Shell! $!";
	my $song = 'sonw.mp3';
	$shell->run("mplayer ${song}", 0, 0);
    return 0;
}
my $t = threads->create(\&thread_play);

## LRC
my $thread_lrc = async
{
    # music information
    my %info=(
"ti" => "ti",
"ar" => "ar",
"al" => "al",
"by" => "by",
        );
    # show time
    my $ptime = 0;
    my $ntime = 0;
    my $lrc = "";

# $command = VIM::Eval("g:ctags_path");

    while (<LRC>)
    {
        chomp;
        if(/\[(.*?)\:(.*?)\](.*)/)
        {
VIM::DoCommand("let g:mvpTitle = '$info{ti}'");
VIM::DoCommand("let g:mvpArticle= '$info{ar}'");
            if($3)
            {
                $ntime = $2 + $1 * 60;
# VIM::Msg(" $info{\"ti\"} $info{\"ar\"}: $lrc");
                    my $step = $ntime - $ptime;
                    # accurate sleeping time
                    usleep($step * 1000000);
                    $lrc = $3;
                    $ptime = $ntime;
            }
            elsif($info{$1} && $info{$1} == $1)
            {
                $info{$1} = $2;
            }
# VIM::Msg("$info{\"ti\"} $info{\"ar\"}: $lrc");
VIM::Msg(" $lrc");
        }
    }
VIM::DoCommand("let g:mvpTitle = 'title'");
VIM::DoCommand("let g:mvpArticle= ''");
}
EOP

endfunction
function! GetMvpInfo()
if g:mvpTitle == "title"
return ""
else
return g:mvpTitle . "-" . g:mvpArticle
endif
endfunction

nmap <leader>mp :call LrcPerl()<cr>
