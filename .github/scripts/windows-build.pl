# Copyright 2023 alex@staticlibs.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Archive::Extract;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Path qw(make_path remove_tree);
use File::Spec::Functions qw(catfile);
use LWP::Simple qw(getstore);

my $pgwin_deps_version = "2023_04_20-1";
my $flexbison_version = "flex-2.6.4_bison-3.8.2-1";
my $diff_version = "v3.6-1";

my $pg_dir = dirname(dirname(dirname(abs_path(__FILE__))));
my $parent_dir = dirname($pg_dir);

sub ensure_dir_empty {
  my $dir = shift;
  if (-d $dir) {
    remove_tree($dir) or die("$!");
  }
  make_path($dir) or die("$!");
}

sub download_pgwin_deps {
  my $url = "https://github.com/wiltondb/pgwin_deps/releases/download/$pgwin_deps_version/pgwin_deps-$pgwin_deps_version.zip";
  my $zip = catfile($parent_dir, "pgwin_deps-$pgwin_deps_version.zip");
  print("Downloading file, url: [$url]\n");
  getstore($url, $zip) or die("$!");
  print("Unpacking file: [$zip]\n");
  my $ae = Archive::Extract->new(archive => $zip);
  $ae->extract(to => $parent_dir) or die("$!");
  my $dir_name = $ae->files->[0];
  return catfile($parent_dir, $dir_name);
}

sub download_flexbison {
  my $url = "https://github.com/wiltondb/winflexbison/releases/download/$flexbison_version/$flexbison_version.zip";
  my $zip = catfile($parent_dir, "$flexbison_version.zip");
  print("Downloading file, url: [$url]\n");
  getstore($url, $zip) or die("$!");
  print("Unpacking file: [$zip]\n");
  my $ae = Archive::Extract->new(archive => $zip);
  $ae->extract(to => $parent_dir) or die("$!");
  my $dir_name = $ae->files->[0];
  return catfile($parent_dir, $dir_name);
}

sub download_diff {
  my $url = "https://github.com/wiltondb/diffutils_win/releases/download/$diff_version/diff.exe";
  my $dir = catfile($parent_dir, "diff");
  ensure_dir_empty($dir);
  my $dest = catfile($dir, "diff.exe");
  print("Downloading file, url: [$url]\n");
  getstore($url, $dest) or die("$!");
  return $dir;
}

my $pgwin_deps_dir = download_pgwin_deps();
$ENV{PGWIN_DEPS_DIR} = "$pgwin_deps_dir/release";
my $flexbison_dir = download_flexbison();
$ENV{PATH} = "$ENV{PATH};$flexbison_dir";
my $diff_dir = download_diff();
$ENV{PATH} = "$ENV{PATH};$diff_dir";

chdir(catfile($pg_dir, "src", "tools", "msvc")) or die("$!");
0 == system("build.bat") or die("$!");
0 == system("vcregress check") or die("$!");
