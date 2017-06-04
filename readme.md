lapi
====

`lapi` is a simple interactive command line interface for the [Linode API](https://www.linode.com/api).

## Installation

This script is a bash script, so as long as bash and its dependencies are installed you should be able to copy it onto your machine and run it.

It depends on the following commands being available:

  * `bash`
  * `curl`
  * `cut`
  * `grep`
  * `jq`

Most of these should be installed on your system already, with the exception of `jq`.

You can also install `lapi` using the Nix package manager: 

```
git clone https://github.com/nixy/lapi.git
cd lapi
nix-env -f . -i
```

If you don't already have Nix installed, you can follow the [installation](https://nixos.org/nix/install) instructions or run the following:

```
curl https://nixos.org/nix/install | sh
```

## Configuration

Since `lapi` interacts with Linode's API, you will need an API key to use it. If you don't already have one, this [guide](https://www.linode.com/docs/platform/api/api-key) should help you generate one.

Once you have your API key you have to expose it to `lapi`, there are two ways to do this. The methods for obtaining the key are attempted in the order listed here and will stop as soon as they find a valid key.

The first method is to store your API key in an environment variable. This is best suited for temporarily testing a key. Since this method uses an environment variable, if you restart your shell or close your terminal you will have to re-enter your key. The name of the variable that is read is LINODE_API_KEY and you can export it like so:

```
export LINODE_API_KEY=<your secret key>
```

The second method uses the `~/.linodecli/config` file, which is the same file used by the [Linode CLI](https://github.com/linode/cli). If you don't already have a configuration, you can easily create one and write your key to it with the following commands:

```
mkdir -p ~/.linodecli/
echo api-key <your secret key>
```

For both these methods you will want to replace `<your secret key>` with your actual API key.

## Usage

`lapi` takes the arguments you provide on the command line and uses them to construct a request for the Linode API. Here is a simple example for how to use `lapi`:

```
lapi test.echo foo=bar 
```

`lapi` will take those arguments and turn it into the following `curl` command which makes a request against the API:

```
curl -sS "https://api.linode.com/?api_key=<your secret key>&api_action=test.echo&foo=bar"
```

It will then print out a pretty version of the response the API gave:

```
{
  "ACTION": "test.echo",
  "DATA": {
    "foo": "bar"
  },
  "ERRORARRAY": []
}
```

The first argument you supply `lapi` will be the API action it attempts to perform and any subsequent arguments will be the parameters to send.

So for example, you can call the [avail.stackscripts](https://www.linode.com/api/utility/avail.stackscripts) action like so:

```
lapi avail.stackscripts
```

If you then wanted to pass some search terms or only find StackScripts for a particular distribution, you could enter the command this way:

```
lapi avail.stackscripts keywords=shadowsocks DistributionVendor=debian
```
