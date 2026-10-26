import {MARGIN} from '../theme';

/** Заголовок сцены слева сверху. */
export const TopLeft: React.FC<{children: React.ReactNode}> = ({children}) => (
	<div style={{position: 'absolute', left: MARGIN, top: MARGIN, right: MARGIN}}>{children}</div>
);
