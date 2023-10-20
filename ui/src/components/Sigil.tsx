import React from 'react';
import '@urbit/sigil-js'

import { useTheme } from '@mui/material/styles';

interface SigilConfig {
  point?: string;
  size?: number;
  foreground?: string;
  background?: string;
  space?: string;
  detail?: string;
}

interface UrbitSigilProps extends React.HTMLAttributes<HTMLElement>, SigilConfig {}
declare global {
  namespace JSX {
    interface IntrinsicElements {
      'urbit-sigil': React.DetailedHTMLProps<UrbitSigilProps, HTMLElement>;
    }
  }
}

export const Sigil = (props: { config: SigilConfig }) => {
  const theme = useTheme();

  const defaultConfig: SigilConfig = {
    point: '~zod',
    size: 24,
    foreground: "#eee",
    background: theme.palette.primary.main,
    space: 'none',
    detail: 'default',
  }

  const {
    point, size, foreground, background, space, detail
  } = { ...defaultConfig, ...props.config };
  return (
    <urbit-sigil point={point} size={size} foreground={foreground} background={background} space={space} detail={detail} />
  )
};
