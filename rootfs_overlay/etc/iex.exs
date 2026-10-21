NervesMOTD.print()

# Add Toolshed helpers to the IEx session
use Toolshed

# battery() prints the battery level
import NervesSurfaceRtHello.Battery, only: [battery: 0]
