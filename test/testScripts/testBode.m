classdef testBode < matlab.unittest.TestCase
    
    properties 
        path
        sysCell
    end

    methods(TestClassSetup)
        function getBenchmarks(testCase)
            testCase.path=pwd;
            if exist('benchmarksSysCell.mat','file')
                temp=load('benchmarksSysCell.mat');
                testCase.sysCell=temp.benchmarksSysCell;
            end

            %the directory "benchmark" is in sssMOR
            p = mfilename('fullpath'); k = strfind(p, 'test\'); 
            pathBenchmarks = [p(1:k-1),'benchmarks'];
            cd(pathBenchmarks);
        end
    end
    
    methods(TestClassTeardown)
        function changePath(testCase)
            cd(testCase.path);
        end
    end
    
    %Test functions
    methods (Test)  
        function testBode1(testCase)
            for i=1:length(testCase.sysCell)
                sys_sss=testCase.sysCell{i};
                sys_ss=ss(sys_sss);
                t=1:100:1000;
                
                [actMag, actPhase, actOmega]=bode(sys_sss,t);
                [expMag, expPhase, expOmega]=bode(ss(sys_ss),t);
                
                %Phase between 0� to 360�
                for j=1:length(actPhase)
                    %if actPhase(:,:,j)<0
                    actPhase(:,:,j)=actPhase(:,:,j)-floor(actPhase(:,:,j)/360)*360;
                    %end
                    %if expPhase(:,:,j)<0
                    expPhase(:,:,j)=expPhase(:,:,j)-floor(expPhase(:,:,j)/360)*360;
                    %end
                end
                
                actSolution={actMag, actPhase, actOmega};
                expSolution={expMag, expPhase, expOmega};
                
                verification (testCase, actSolution, expSolution);
                verifyInstanceOf(testCase, actMag , 'double', 'Instances not matching');
                verifyInstanceOf(testCase, actPhase , 'double', 'Instances not matching');
                verifyInstanceOf(testCase, actOmega , 'double', 'Instances not matching');
                verifySize(testCase, actMag, size(expMag), 'Size not matching');
                verifySize(testCase, actPhase, size(expPhase), 'Size not matching');
                verifySize(testCase, actOmega, size(expOmega), 'Size not matching');
            end
        end
    end
end
    
function [] = verification (testCase, actSolution, expSolution)
          verifyEqual(testCase, actSolution, expSolution, 'RelTol', 0.1,'AbsTol',0.000001, ...
               'Difference between actual and expected exceeds relative tolerance');
end