#!/usr/bin/env coffee

import chalk from 'chalk'
import axios from 'axios'
import sleep from 'await-sleep'

{defaults} = axios

defaults.timeout = 30000
defaults.retry = 3
defaults.retryDelay = 3000

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
        source.cancel({
          code:'TIMEOUT'
          config
        })
      timeout or defaults.timeout
    )
    config.cancelToken = token
    return config
  reject
)

request = axios.Axios::request

axios.Axios::request = (config)->
  while 1
    try
      r = await request.call(@,config)
      break
    catch err
      _config = err.config
      if 'retry' not of config
        config.retry = _config.retry

      console.error(
        chalk.redBright err.code
        chalk.gray config.method
        chalk.blueBright config.url
      )
      clearTimeout  _config.cancelToken.timer
      if not --config.retry
        throw err

      await sleep _config.retryDelay

  _config = r.config
  clearTimeout _config.cancelToken.timer
  delete _config.cancelToken

  return r

export default axios

