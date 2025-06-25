import { NitroModules } from 'react-native-nitro-modules'
import type { NitroBackgroundTimer as NitroBackgroundTimerSpecs } from './specs/background-timer.nitro'

const NitroBackgroundTimer =
  NitroModules.createHybridObject<NitroBackgroundTimerSpecs>(
    'NitroBackgroundTimer'
  )

class BackgroundTimer {
  private callbackId = 0
  private timeoutCallbacks = new Map<number, () => void>()
  private intervalCallbacks = new Map<number, () => void>()

  setTimeout(fn: () => void, ms: number): number {
    const id = ++this.callbackId
    try {
      NitroBackgroundTimer.setTimeout(id, ms, () => {
        const cb = this.timeoutCallbacks.get(id)
        if (cb) {
          cb()
          this.timeoutCallbacks.delete(id)
        }
      })
    } catch (nativeErr) {
      console.error(
        `[NitroTimer] Failed to call native setTimeout (id: ${id}):`,
        nativeErr
      )
    }
    this.timeoutCallbacks.set(id, fn)
    return id
  }

  clearTimeout(id: number) {
    try {
      if (!id) return
      NitroBackgroundTimer.clearTimeout(id)
      this.timeoutCallbacks.delete(id)
    } catch (err) {
      console.error(
        `[NitroTimer] Failed to call native clearTimeout (id: ${id}):`,
        err
      )
    }
  }

  setInterval(fn: () => void, ms: number): number {
    const id = ++this.callbackId
    try {
      NitroBackgroundTimer.setInterval(id, ms, () => {
        const cb = this.intervalCallbacks.get(id)
        if (cb) cb()
      })
    } catch (nativeErr) {
      console.error(
        `[NitroTimer] Failed to call native setInterval (id: ${id}):`,
        nativeErr
      )
    }
    this.intervalCallbacks.set(id, fn)
    return id
  }

  clearInterval(id: number) {
    try {
      if (!id) return
      NitroBackgroundTimer.clearInterval(id)
      this.intervalCallbacks.delete(id)
    } catch (err) {
      console.error(
        `[NitroTimer] Failed to call native clearInterval (id: ${id}):`,
        err
      )
    }
  }
}

export default new BackgroundTimer()
