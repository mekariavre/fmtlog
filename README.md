# fmtlog

A simple Ruby script to pretty-print and transform JSON logs, with special handling for stack traces. Designed to be used in log processing pipelines, especially for Go applications.

## Features
- Reads JSON log lines from standard input
- Formats and colorizes output using `jq` (if available)
- Transforms stack traces for better readability
- Gracefully handles malformed input and errors
- Supports interruption with Ctrl+C

## Installation

### Quick Install

You can install `fmtlog` system-wide using the provided install script:

```sh
curl -fsSL https://raw.githubusercontent.com/mekariavre/fmtlog/main/install.sh | sudo sh
```

#### (Optional) Install `jq` for colorized output:

```sh
brew install jq  # macOS
sudo apt-get install jq  # Ubuntu/Debian
```

## Usage

```sh
# Example usage with Go server logs:
$ go run . server | fmtlog
{
	"level": "error",
    "ts": "2025-09-01T21:33:04+07:00",
	"msg": "something failed",
    "resource": {
        "service.name": "time_off_service",
        "service.env": "local"
    }
}
Failed to transform: 767: unexpected token at '09/01 21:33:04 error failed to create storage client error="bucket name  len is between [3-63],now is 0"'
2025/09/01 21:33:04 ERROR failed to create storage client error="bucket name  len is between [3-63],now is 0"
{
  "level": "info",
  "ts": "2025-09-01T21:33:04+07:00",
  "msg": "Server is running on http://localhost:3100",
  "resource": {
    "service.name": "time_off_service",
    "service.env": "local"
  }
}
```

## Requirements
- Ruby (>= 2.5)
- [jq](https://stedolan.github.io/jq/) (optional, for colorized output)

## License
MIT
