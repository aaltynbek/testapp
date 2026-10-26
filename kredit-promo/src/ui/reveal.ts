import type {CSSProperties} from 'react';
import {interpolate, spring, useCurrentFrame, useVideoConfig} from 'remotion';

/**
 * Появление пружиной (damping 200) со сдвигом снизу 24 px с задержкой `delay`
 * и исчезновение за последние 12 кадров текущей <Sequence>.
 */
export function useReveal(delay = 0): CSSProperties {
	const frame = useCurrentFrame();
	const {fps, durationInFrames} = useVideoConfig();
	const p = spring({frame: frame - delay, fps, config: {damping: 200}});
	const out = interpolate(frame, [durationInFrames - 12, durationInFrames], [1, 0], {
		extrapolateLeft: 'clamp',
		extrapolateRight: 'clamp',
	});
	return {
		opacity: p * out,
		transform: `translateY(${(1 - p) * 24}px)`,
	};
}
