import axios from '../src/index'
import test from 'tape'



test 'axios', (t)=>
  r = await axios.get("http://baidu.com")
  console.log r.data
  t.end()
