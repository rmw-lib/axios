export default new Proxy(
  Object
  {
    get: (obj, attr) ->
      (self, desc)=>
        console.log self, attr, desc
        Object.defineProperty self::, attr, desc
  }
)
