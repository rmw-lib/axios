import axios from '../src/index'
import test from 'tape'



test 'axios', (t)=>
  r = await axios.get("http://z.cn")
  console.log Object.keys r
  t.end()
