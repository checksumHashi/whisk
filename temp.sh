#!/bin/bash

choice=$(gum choose "fix" "beans")

get_name() {
  echo "John"
}

echo "You are $(get_name)"
