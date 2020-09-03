#!/usr/bin/env coffee

import axios from '../src/index'
# import test from 'tape'

do =>
  r = await axios.get("http://baidu.com")
  console.log ">", r.data
  r = await axios.get("http://xczcv.baidu.com")
  console.log r.data
  t.end()
