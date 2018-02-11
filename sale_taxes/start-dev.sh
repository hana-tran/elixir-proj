#!/usr/bin/env bash
# Example usage: ./start-dev author

cd `dirname $0`

make && exec iex -S mix
