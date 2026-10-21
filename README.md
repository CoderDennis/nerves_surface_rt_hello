# NervesSurfaceRtHello

A small [Nerves](https://nerves-project.org/) app for the original Microsoft
Surface RT (2012, NVIDIA Tegra 3). It's the test app for
[nerves_system_surface_rt](https://github.com/CoderDennis/nerves_system_surface_rt):
it builds firmware for the `surface_rt` target and proves that the system
works on real hardware.

On the Surface RT it:

  * boots to an IEx prompt on the built-in screen, with the Touch/Type Cover
    or a USB keyboard
  * joins Wi-Fi with [VintageNet](https://github.com/nerves-networking/vintage_net)
    and accepts SSH logins (`ssh nerves.local`) and firmware updates
    (`mix upload`)
  * shows the battery status in IEx and in the message of the day (see
    [Battery status](#battery-status))

## Getting Started

You need a jailbroken Surface RT with Nerves installed on its eMMC. The
Surface RT can't boot from microSD, so the first install isn't a plain
`mix burn`. See the system's README for the
[jailbreak](https://github.com/CoderDennis/nerves_system_surface_rt#part-1-jailbreak-the-surface-rt)
and [installing](https://github.com/CoderDennis/nerves_system_surface_rt#installing).

This app uses the system from a local checkout next to it, so that system
changes can be tested before they're released. Clone both into the same
directory:

```sh
git clone https://github.com/CoderDennis/nerves_system_surface_rt.git
git clone https://github.com/CoderDennis/nerves_surface_rt_hello.git
cd nerves_surface_rt_hello
```

Then build firmware for the `surface_rt` target:

  * `export MIX_TARGET=surface_rt`, or prefix every command with
    `MIX_TARGET=surface_rt`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`. The first build also builds the
    Nerves system with Buildroot, in Docker on macOS, which takes a while.
  * Update a Surface RT that's on your network with `mix upload nerves.local`

The Erlang and Elixir versions in `.tool-versions` must match the system's
Erlang/OTP major version (29).

SSH logins use your public keys from `~/.ssh` (`id_rsa.pub`, `id_ecdsa.pub`
or `id_ed25519.pub`), which are built into the firmware.

### Wi-Fi

Either build the network into the firmware:

```sh
NERVES_WIFI_SSID=MyNetwork NERVES_WIFI_PSK=secret MIX_TARGET=surface_rt mix firmware
```

or set it at the IEx prompt on the Surface RT, which saves it on the device:

```elixir
VintageNetWiFi.quick_configure("MyNetwork", "secret")
```

## Battery status

At the IEx prompt, `battery` prints a one-line summary:

```elixir
iex> battery
82% Discharging (-598 mA, 7952 mV)
```

`NervesSurfaceRtHello.Battery.info/0` returns the details as a map:

```elixir
iex> NervesSurfaceRtHello.Battery.info()
%{
  status: "Full",
  current: 0,
  ac_online: true,
  capacity: 100,
  charge_full: 3256,
  charge_full_design: 4257,
  charge_now: 3256,
  cycle_count: 81,
  voltage: 8329
}
```

Voltages are in mV, currents in mA (negative while discharging) and charges
in mAh. The message of the day, shown when IEx starts and on SSH login, has
a Battery row. The values come from the Surface RT's embedded controller
driver under `/sys/class/power_supply`.

## Learn more

  * nerves_system_surface_rt: https://github.com/CoderDennis/nerves_system_surface_rt
  * Official docs: https://nerves.hexdocs.pm/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Elixir Discord #nerves channel: https://discord.gg/elixir
  * Source: https://github.com/nerves-project/nerves

## License

Copyright 2026 Dennis Palmer

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
