#!/usr/bin/env coffee

import axiosRetry from 'axios-retry'
import chalk from 'chalk'
import axios from 'axios'

{defaults} = axios

defaults.timeout = 30000

axiosRetry(
  axios
  retries: 3
)

reject = (error) =>
  return Promise.reject(error)

{CancelToken} = axios

axios.interceptors.request.use(
  (config) =>
    # 参考 ： 超时不起作用·问题＃647·axios / axios : https://t.cn/A6UgrogG
    {cancelToken,timeout} = config

    source = cancelToken or CancelToken.source()
    {token} = source
    token.timer = setTimeout(
      =>
        source.cancel('timeout')
      timeout or defaults.timeout
    )
    config.cancelToken = token
    return config
  reject
)
axios.interceptors.response.use(
  (response)->
    clearTimeout response.config.cancelToken.timer
    return response
  reject
)

export default axios

