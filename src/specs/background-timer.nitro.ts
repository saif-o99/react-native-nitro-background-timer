import { type HybridObject } from 'react-native-nitro-modules'

export interface NitroBackgroundTimer
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  setTimeout(
    id: number,
    duration: number,
    callback: (nativeId: number) => void
  ): number

  clearTimeout(id: number): void

  setInterval(
    id: number,
    interval: number,
    callback: (nativeId: number) => void
  ): number

  clearInterval(id: number): void
}
