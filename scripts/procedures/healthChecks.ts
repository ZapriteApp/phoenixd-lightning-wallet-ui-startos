import { types as T, healthUtil } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  async "interface"(effects, duration) {
    return healthUtil.checkWebUrl("http://phoenixd-lightning-wallet-ui.embassy:3000")(effects, duration).catch(healthUtil.catchError(effects))
  },
};