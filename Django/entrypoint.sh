#!/bin/sh
gunicorn djangodockertest.wsgi:application --bind 10.0.0.10:8000
