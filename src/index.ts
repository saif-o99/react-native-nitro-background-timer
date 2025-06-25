import { NitroModules } from 'react-native-nitro-modules'
import type { NitroBackgroundTimer } from './specs/background-timer.nitro'

const NitroBackgroundTimer =
  NitroModules.createHybridObject<NitroBackgroundTimer>('NitroBackgroundTimer')

class BackgroundTimer {
  private static callbackId = 0
  private static timeoutCallbacks = new Map<number, () => void>()
  private static intervalCallbacks = new Map<number, () => void>()

  static setTimeout(fn: () => void, ms: number): number {
    const id = ++this.callbackId

    NitroBackgroundTimer.setTimeout(id, ms, () => {
      const cb = this.timeoutCallbacks.get(id)
      if (cb) {
        cb()
        this.timeoutCallbacks.delete(id)
      }
    })

    this.timeoutCallbacks.set(id, fn)
    return id
  }

  static clearTimeout(id: number) {
    NitroBackgroundTimer.clearTimeout(id)
    this.timeoutCallbacks.delete(id)
  }

  static setInterval(fn: () => void, ms: number): number {
    const id = ++this.callbackId

    NitroBackgroundTimer.setInterval(id, ms, () => {
      const cb = this.intervalCallbacks.get(id)
      if (cb) cb()
    })

    this.intervalCallbacks.set(id, fn)
    return id
  }

  static clearInterval(id: number) {
    NitroBackgroundTimer.clearInterval(id)
    this.intervalCallbacks.delete(id)
  }
}

export default BackgroundTimer
