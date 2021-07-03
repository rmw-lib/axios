#!/usr/bin/env coffee

import chalk from 'chalk'
import axios from 'axios'
import sleep from 'await-sleep'

{defaults, Cancel, CancelToken} = axios

defaults.timeout = 30000
defaults.retry = 3
defaults.retryDelay = 3000

reject = (error) =>
  return Promise.reject(error)




request = axios.Axios::request

axios.Axios::request = (config)->
  {cancelToken,timeout,retry, retryDelay} = config

  timeout = timeout or defaults.timeout
  retry = retry or defaults.retry
  retryDelay = retryDelay or defaults.retryDelay

  source = CancelToken.source()
  {token} = source
  config.CancelToken = token
  if cancelToken
    cancelToken.promise.then source.cancel

  loop
    timer = setTimeout(
      =>
        source.cancel({
          code:'TIMEOUT'
          config
        })
      timeout
    )
    try
      r = await request.call(@,config)
      break
    catch err
      if err instanceof Cancel
        err = err.message

      response = err.response
      if response
        status = response.status
      else
        status = err

      console.error(
        chalk.gray "axios"
        chalk.gray config.method
        chalk.redBright status
        chalk.blueBright config.url
      )
      if response
        console.error(response.data)
      if --retry <= 0
        throw err

      await sleep retryDelay
    finally
      clearTimeout timer
  if not cancelToken
    delete config.cancelToken
  return r

export default axios

