function rw = allan_get_rw (tau, allan, dt)
% allan_get_rw: gets random walk values from Allan variance.
%
% INPUT
%   tau:   Nx1 Allan variance time vector (seconds).
%   allan: Nx1 Allan variance.
%   dt: sampling time from the signal under analysis.
%
% OUTPUT
%   rw: random walk values.
%
%   Copyright (C) 2014, Rodrigo Gonzalez, all rights reserved.
%
%   This file is part of NaveGo, an open-source MATLAB toolbox for
%   simulation of integrated navigation systems.
%
%   NaveGo is free software: you can redistribute it and/or modify
%   it under the terms of the GNU Lesser General Public License (LGPL)
%   version 3 as published by the Free Software Foundation.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with this program. If not, see
%   <http://www.gnu.org/licenses/>.
%
% Reference:
%
%
% Version: 002
% Date:    2021/03/01
% Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>
% URL:     https://github.com/rodralez/navego

fprintf('\nallan_get_rw: Random angle value is valid ONLY if Allan variance curve presents a -0.5 slope\n')

idx = find ( tau == 1 );    % Index for tau = 1 s

if ( ~isempty(idx) )        % if there is a precise value for tau = 1 s...
    
    rw =  allan(idx);
    
else                        % if not...
    
    % Upsample values between 0.5 < tau < 1.5
    idx = find ( tau >= 0.5 & tau <= 2);
    
    if ( isempty(idx) )
        error('allan_get_rw: ERROR, idx is empty\n')
    end
    
    tau_o = tau(idx);
    allan_o = allan(idx);
    
    % Upsampled time vector
    tau_us = tau(idx(1)):dt:tau(idx(end));
    
    % Upsampled allan var. vector
    allan_us = interp1(tau_o, allan_o, tau_us, 'linear');
    
    jdx = find (tau_us == 1); % Index of tau = 1 s
    
    if ( isempty(jdx) )
        error('allan_get_rw: ERROR, jdx is empty\n')
    end
    
    rw =  allan_us(jdx);
    
end
