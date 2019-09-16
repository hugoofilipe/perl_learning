#CONSTANTS
package Lib::Manager;

use base 'Exporter';

use constant DEBUG          => 1;

use constant READ_FROM_FILE => 0;
use constant READ_FROM_YAML => 0;

our @EXPORT_OK = [ 'DEBUG', 'READ_FROM_FILE', 'READ_FROM_YAML' ];

1;
